import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_tag_chip.dart';
import '../../../core/widgets/spot_card_shell.dart';
import '../../../models/spot.dart';

class SpotCard extends StatelessWidget {
  const SpotCard({super.key, required this.spot, this.onTap});

  final Spot spot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SpotCardShell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.photo_outlined,
              size: 42,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            spot.placeName ?? 'Unknown place',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(spot.caption, maxLines: 3, overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  spot.author.username.characters.first.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(child: Text('@${spot.author.username}')),
              if (spot.budgetLabel != null)
                Text(
                  spot.budgetLabel!,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
            ],
          ),
          if (spot.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final tag in spot.tags.take(3)) AppTagChip(label: tag),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
