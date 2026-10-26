import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';

class CreateSpotReviewArgs {
  const CreateSpotReviewArgs({
    required this.placeName,
    required this.caption,
    this.coordinates,
    this.photoReference,
    this.tags = const [],
    this.budget = 'Not specified',
  });

  final String placeName;
  final String caption;
  final LatLng? coordinates;
  final String? photoReference;
  final List<String> tags;
  final String budget;
}

class CreateSpotReviewScreen extends StatelessWidget {
  const CreateSpotReviewScreen({super.key, required this.args});

  final CreateSpotReviewArgs args;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Review your spot')),
      body: ListView(
        padding: AppSpacing.page,
        children: [
          Text(
            'Check your spot before publishing',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Make sure the details, tags, and budget are accurate.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Preview Card ──
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo Banner
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 48,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                args.photoReference ?? 'No photo attached',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Budget badge overlay
                          Positioned(
                            bottom: AppSpacing.sm,
                            left: AppSpacing.sm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.payments_outlined,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    args.budget,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
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

                  // Place name & Coordinates
                  Text(
                    args.placeName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (args.coordinates != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${args.coordinates!.latitude.toStringAsFixed(4)}°, ${args.coordinates!.longitude.toStringAsFixed(4)}°',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),

                  // Caption
                  Text(args.caption, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.md),

                  // Budget & Tags summary section
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Budget: ${args.budget}',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  if (args.tags.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final tag in args.tags)
                          Chip(
                            label: Text('#$tag'),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                      ],
                    )
                  else
                    Text(
                      'No tags added',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Publish Action Button ──
          AppButton(
            label: 'Publish spot',
            icon: Icons.check_circle_outline,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Spot published successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          const SizedBox(height: AppSpacing.sm),

          // Secondary Edit Details Button
          AppButton(
            label: 'Edit details',
            style: AppButtonStyle.secondary,
            icon: Icons.edit_outlined,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
