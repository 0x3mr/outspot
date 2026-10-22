import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_page_padding.dart';
import '../../../data/fixtures/sample_data.dart';
import '../../feed/widgets/spot_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: AppSpacing.page,
    children: [
      AppPagePadding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Icon(
                Icons.person,
                size: 38,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              sampleProfile.displayName ?? sampleProfile.username,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text('@${sampleProfile.username}'),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Edit profile',
              style: AppButtonStyle.secondary,
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile editing is coming soon.'),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      Text('Your spots', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: AppSpacing.sm),
      for (final spot in sampleSpots.where(
        (spot) => spot.author.id == sampleProfile.id,
      )) ...[SpotCard(spot: spot), const SizedBox(height: AppSpacing.sm)],
    ],
  );
}
