import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/fixtures/sample_data.dart';
import '../widgets/spot_marker_preview.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: AppSpacing.page,
    children: [
      Text('Find a spot nearby', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: AppSpacing.md),
      Container(
        height: 190,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.primary
                  .withValues(alpha: .5),
            ),
            Positioned(
              top: 42,
              left: 72,
              child: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
            ),
            Positioned(
              bottom: 34,
              right: 84,
              child: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.tertiary,
                size: 32,
              ),
            ),
            const Positioned(
              left: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Text('Map preview'),
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      Text('Spots on the map', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: AppSpacing.sm),
      for (final spot in sampleSpots) ...[
        SpotMarkerPreview(spot: spot),
        const SizedBox(height: AppSpacing.sm),
      ],
      const SizedBox(height: AppSpacing.md),
    ],
  );
}
