import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/fixtures/sample_data.dart';
import '../../../models/spot.dart';
import '../widgets/spot_marker_preview.dart';

/// Explore screen that renders an interactive OpenStreetMap via flutter_map.
///
/// Sample spot coordinates are plotted as tappable markers. Tapping a marker
/// shows a preview card at the bottom. The map does **not** request device
/// location automatically.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final MapController _mapController = MapController();

  /// The currently selected spot (shown in the bottom preview card).
  Spot? _selectedSpot;

  /// Only spots that have valid coordinates.
  late final List<Spot> _mappableSpots;

  /// Centre the map on Cairo, Egypt where the sample data lives.
  static final _defaultCenter = LatLng(30.0370, 31.2270);
  static const _defaultZoom = 12.5;

  @override
  void initState() {
    super.initState();
    _mappableSpots = sampleSpots
        .where((s) => s.latitude != null && s.longitude != null)
        .toList();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  // ───────────────────────── build ─────────────────────────

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Map ──
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _defaultCenter,
            initialZoom: _defaultZoom,
            minZoom: 3,
            maxZoom: 18,
            // Deselect marker when tapping empty map area.
            onTap: (tapPosition, point) => _clearSelection(),
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            // ── Tile layer (OpenStreetMap) ──
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.outspot.app',
              maxZoom: 19,
            ),

            // ── Markers ──
            MarkerLayer(markers: _buildMarkers()),

            // ── Attribution (always visible) ──
            const RichAttributionWidget(
              alignment: AttributionAlignment.bottomLeft,
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
          ],
        ),

        // ── "Explore" header chip ──
        Positioned(
          top: AppSpacing.md,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.softBorder),
                boxShadow: const [AppColors.subtleCardShadow],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.explore_rounded,
                    size: 18,
                    color: AppColors.electricPurple,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Find a spot nearby',
                    style: const TextStyle(
                      color: AppColors.midnightInk,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Re-centre FAB ──
        Positioned(
          bottom: _selectedSpot != null ? 200 : AppSpacing.xl,
          right: AppSpacing.md,
          child: _MapActionButton(
            icon: Icons.my_location_rounded,
            tooltip: 'Re-centre map',
            onPressed: _recentre,
          ),
        ),

        // ── Bottom preview card (slides up when a marker is selected) ──
        AnimatedPositioned(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          bottom: _selectedSpot != null ? 0 : -200,
          left: 0,
          right: 0,
          child: _selectedSpot != null
              ? _BottomPreviewCard(
                  spot: _selectedSpot!,
                  onClose: _clearSelection,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // ───────────────────────── markers ─────────────────────────

  List<Marker> _buildMarkers() {
    return _mappableSpots.map((spot) {
      final isSelected = _selectedSpot?.id == spot.id;

      return Marker(
        width: 48,
        height: 48,
        point: LatLng(spot.latitude!, spot.longitude!),
        child: GestureDetector(
          onTap: () => _selectSpot(spot),
          child: AnimatedScale(
            scale: isSelected ? 1.25 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            child: _SpotPin(isSelected: isSelected),
          ),
        ),
      );
    }).toList();
  }

  // ───────────────────────── actions ─────────────────────────

  void _selectSpot(Spot spot) {
    setState(() => _selectedSpot = spot);

    // Smoothly animate the map to the selected marker.
    _mapController.move(
      LatLng(spot.latitude!, spot.longitude!),
      _mapController.camera.zoom.clamp(13.0, 18.0),
    );
  }

  void _clearSelection() {
    if (_selectedSpot != null) {
      setState(() => _selectedSpot = null);
    }
  }

  void _recentre() {
    _mapController.move(_defaultCenter, _defaultZoom);
    _clearSelection();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private helper widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Gradient pin icon used for each map marker.
class _SpotPin extends StatelessWidget {
  const _SpotPin({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isSelected ? 36 : 30,
          height: isSelected ? 36 : 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            border: Border.all(color: Colors.white, width: isSelected ? 3 : 2),
            boxShadow: [
              if (isSelected) AppColors.glowShadow,
              const BoxShadow(
                color: Color(0x33000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.place_rounded, color: Colors.white, size: 16),
        ),
        // Small triangle pointer beneath the circle.
        CustomPaint(
          size: const Size(10, 6),
          painter: _PinPointerPainter(
            color: isSelected ? AppColors.deepViolet : AppColors.electricPurple,
          ),
        ),
      ],
    );
  }
}

/// Paints a tiny downward-pointing triangle below the marker circle.
class _PinPointerPainter extends CustomPainter {
  _PinPointerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PinPointerPainter old) => old.color != color;
}

/// Small circular action button overlaid on the map.
class _MapActionButton extends StatelessWidget {
  const _MapActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceWhite.withValues(alpha: 0.94),
        border: Border.all(color: AppColors.softBorder),
        boxShadow: const [AppColors.subtleCardShadow],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.electricPurple, size: 22),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}

/// Preview card that slides up from the bottom when a marker is tapped.
class _BottomPreviewCard extends StatelessWidget {
  const _BottomPreviewCard({required this.spot, required this.onClose});

  final Spot spot;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(top: BorderSide(color: AppColors.softBorder)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Drag handle ──
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.softBorder,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // ── Close button row ──
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lavenderMist,
                        border: Border.all(color: AppColors.softBorder),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: AppColors.slateGray,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              // ── Spot preview card (reuses existing widget) ──
              SpotMarkerPreview(spot: spot, isSelected: true),
            ],
          ),
        ),
      ),
    );
  }
}
