import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/spot_card_shell.dart';
import '../../../models/spot.dart';

class SpotMarkerPreview extends StatelessWidget {
  const SpotMarkerPreview({
    super.key,
    required this.spot,
    this.isSelected = false,
  });

  final Spot spot;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SpotCardShell(
      onTap: () =>
          Navigator.pushNamed(context, AppRoutes.spotDetail, arguments: spot),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 20,
                color: AppColors.electricPurple,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  spot.placeName ?? 'Unknown place',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.midnightInk,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.softLavender,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Selected',
                    style: TextStyle(
                      color: AppColors.deepViolet,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            spot.caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.midnightInk.withValues(alpha: 0.85),
            ),
          ),
          if (spot.latitude != null && spot.longitude != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${spot.latitude!.toStringAsFixed(4)}, ${spot.longitude!.toStringAsFixed(4)}',
                  style: const TextStyle(
                    color: AppColors.slateGray,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      'View details',
                      style: TextStyle(
                        color: AppColors.electricPurple,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 14,
                      color: AppColors.electricPurple,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
