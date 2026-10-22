import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_tag_chip.dart';
import '../../../core/widgets/spot_card_shell.dart';
import '../../../models/spot.dart';

class SpotDetailView extends StatelessWidget {
  const SpotDetailView({super.key, required this.spot});

  final Spot spot;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.page,
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.photo_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SpotCardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                spot.placeName ?? 'Unknown place',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(spot.caption),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 18),
                  const SizedBox(width: AppSpacing.xs),
                  Text('@${spot.author.username}'),
                ],
              ),
              if (spot.budgetLabel != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text('Budget: ${spot.budgetLabel}'),
              ],
              if (spot.tags.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final tag in spot.tags) AppTagChip(label: tag),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Comments', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        const Text('Comments will appear here.'),
      ],
    );
  }
}
