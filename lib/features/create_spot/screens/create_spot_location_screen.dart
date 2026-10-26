import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_page_padding.dart';

class CreateSpotLocationScreen extends StatefulWidget {
  const CreateSpotLocationScreen({super.key, this.initialLocation});

  final LatLng? initialLocation;

  @override
  State<CreateSpotLocationScreen> createState() =>
      _CreateSpotLocationScreenState();
}

class _CreateSpotLocationScreenState extends State<CreateSpotLocationScreen> {
  final MapController _mapController = MapController();

  // Default starting position (Downtown Cairo, consistent with ExploreScreen)
  static final LatLng _initialCenter = LatLng(30.0370, 31.2270);
  static const double _initialZoom = 15.0;

  // The current coordinate under the center pin
  late LatLng _selectedLocation;
  bool _initialized = false;
  bool _isMoving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs is LatLng) {
        _selectedLocation = routeArgs;
      } else {
        _selectedLocation = widget.initialLocation ?? _initialCenter;
      }
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a location')),
      body: AppPagePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Where is your spot?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Pan and zoom the map to place the pin at the exact spot.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Map container
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. Interactive OpenStreetMap
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _selectedLocation,
                        initialZoom: _initialZoom,
                        minZoom: 3,
                        maxZoom: 18,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all,
                        ),
                        // Listen for camera movements to update coordinates in real time
                        onPositionChanged: (MapCamera camera, bool hasGesture) {
                          setState(() {
                            _selectedLocation = camera.center;
                            _isMoving = hasGesture;
                          });
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.outspot.app',
                          maxZoom: 19,
                        ),
                        const RichAttributionWidget(
                          alignment: AttributionAlignment.bottomRight,
                          attributions: [
                            TextSourceAttribution('OpenStreetMap contributors'),
                          ],
                        ),
                      ],
                    ),

                    // 2. Fixed Center Pin (with IgnorePointer so map gestures work)
                    IgnorePointer(
                      child: Center(
                        child: Transform.translate(
                          // Shift up by half of the icon size (48 / 2 = 24)
                          // so the bottom tip of the pin aligns with the exact center
                          offset: const Offset(0, -24),
                          child: AnimatedScale(
                            // Slight scale-up effect while dragging to feel responsive
                            scale: _isMoving ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 150),
                            child: Icon(
                              Icons.location_pin,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 3. Coordinate preview badge at the bottom-left
                    Positioned(
                      bottom: AppSpacing.md,
                      left: AppSpacing.md,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.my_location,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${_selectedLocation.latitude.toStringAsFixed(4)}°, '
                              '${_selectedLocation.longitude.toStringAsFixed(4)}°',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // 4. Continue / Confirm button passing coordinates
            AppButton(
              label: 'Confirm location',
              icon: Icons.arrow_forward,
              onPressed: () {
                // Return or pass the LatLng coordinates to the create spot details flow
                Navigator.pushNamed(
                  context,
                  AppRoutes.createSpotDetails,
                  arguments: _selectedLocation,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
