import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_page_padding.dart';

class CreateSpotLocationScreen extends StatefulWidget {
  const CreateSpotLocationScreen({super.key});

  @override
  State<CreateSpotLocationScreen> createState() =>
      _CreateSpotLocationScreenState();
}

class _CreateSpotLocationScreenState extends State<CreateSpotLocationScreen> {
  bool _locationSelected = false;

  @override
  Widget build(BuildContext context) => Scaffold(
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
          const Text('Tap the map to place a pin. You can add details next.'),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: InkWell(
                  onTap: () => setState(() => _locationSelected = true),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _MapGridPainter(
                            Theme.of(context).colorScheme.primary
                                .withValues(alpha: .12),
                          ),
                        ),
                      ),
                      if (_locationSelected)
                        Icon(
                          Icons.location_on,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      else
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_location_alt_outlined,
                              size: 44,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            const Text('Tap to place a pin'),
                          ],
                        ),
                      Positioned(
                        bottom: AppSpacing.md,
                        left: AppSpacing.md,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            child: Text(
                              _locationSelected
                                  ? 'Downtown Cairo'
                                  : 'Map preview',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Continue',
            icon: Icons.arrow_forward,
            onPressed: _locationSelected
                ? () =>
                      Navigator.pushNamed(context, AppRoutes.createSpotDetails)
                : null,
          ),
        ],
      ),
    ),
  );
}

class _MapGridPainter extends CustomPainter {
  _MapGridPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    for (var x = -size.height; x < size.width; x += 54) {
      canvas.drawLine(
        Offset(x.toDouble(), 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
    for (var y = 28.0; y < size.height; y += 64) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 18), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) =>
      oldDelegate.color != color;
}
