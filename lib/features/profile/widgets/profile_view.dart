import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../../../core/widgets/app_page_padding.dart';
import '../../../core/widgets/app_state_widgets.dart';
import '../../../models/profile.dart';
import '../../../models/spot.dart';
import '../../feed/widgets/spot_card.dart';
import 'profile_avatar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.profile,
    required this.spots,
    this.isLoadingSpots = false,
    this.onEditProfile,
    this.onOpenSpot,
    this.onCreateSpot,
  });

  final Profile profile;
  final List<Spot> spots;
  final bool isLoadingSpots;
  final VoidCallback? onEditProfile;
  final ValueChanged<Spot>? onOpenSpot;
  final VoidCallback? onCreateSpot;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bio = profile.bio?.trim() ?? '';
    final joinedAt = profile.joinedAt;
    final likesReceived = spots.fold<int>(
      0,
      (total, spot) => total + (spot.likeCount ?? 0),
    );

    return ListView(
      padding: AppSpacing.page,
      children: [
        AppPagePadding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            children: [
              ProfileAvatar(profile: profile),
              const SizedBox(height: AppSpacing.sm),
              Text(
                profile.displayName ?? profile.username,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleLarge,
              ),
              Text(
                '@${profile.username}',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (bio.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  bio,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.midnightInk.withValues(alpha: 0.88),
                    height: 1.4,
                  ),
                ),
              ],
              if (joinedAt != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.slateGray,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      'Joined ${formatJoinDate(joinedAt)}',
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.slateGray,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              _ProfileStats(
                postCount: spots.length,
                likesReceived: likesReceived,
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Edit profile',
                style: AppButtonStyle.secondary,
                onPressed: onEditProfile,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Your spots', style: textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        if (isLoadingSpots && spots.isEmpty)
          const AppLoadingIndicator(label: 'Loading your spots')
        else if (spots.isEmpty)
          AppEmptyState(
            title: 'No spots yet',
            message: 'Places you share will show up here.',
            icon: Icons.place_outlined,
            actionLabel: onCreateSpot == null ? null : 'Create a spot',
            onAction: onCreateSpot,
          )
        else
          for (final spot in spots) ...[
            SpotCard(
              spot: spot,
              onTap: onOpenSpot == null ? null : () => onOpenSpot!(spot),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
      ],
    );
  }
}

class _ProfileStats extends StatelessWidget {
  const _ProfileStats({required this.postCount, required this.likesReceived});

  final int postCount;
  final int likesReceived;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    decoration: BoxDecoration(
      color: AppColors.surfaceWhite,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.softBorder),
      boxShadow: const [AppColors.subtleCardShadow],
    ),
    child: Row(
      children: [
        Expanded(
          child: _ProfileStat(
            value: postCount,
            label: postCount == 1 ? 'Post' : 'Posts',
          ),
        ),
        Container(width: 1, height: 32, color: AppColors.softBorder),
        Expanded(
          child: _ProfileStat(value: likesReceived, label: 'Likes received'),
        ),
      ],
    ),
  );
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        '$value',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.midnightInk,
        ),
      ),
      Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: AppColors.slateGray),
      ),
    ],
  );
}

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String formatJoinDate(DateTime date) =>
    '${_monthNames[date.month - 1]} ${date.year}';
