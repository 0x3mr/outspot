import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/spot_card_shell.dart';
import '../../../models/spot.dart';

class SpotMarkerPreview extends StatelessWidget {
  const SpotMarkerPreview({super.key, required this.spot});

  final Spot spot;

  @override
  Widget build(BuildContext context) {
    return SpotCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            spot.placeName ?? 'Unknown place',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(spot.caption),
          if (spot.latitude != null && spot.longitude != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${spot.latitude!.toStringAsFixed(4)}, ${spot.longitude!.toStringAsFixed(4)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
