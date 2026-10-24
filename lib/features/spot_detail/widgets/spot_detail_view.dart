import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_tag_chip.dart';
import '../../../data/fixtures/sample_data.dart';
import '../../../models/comment.dart';
import '../../../models/spot.dart';

class SpotDetailView extends StatelessWidget {
  const SpotDetailView({super.key, required this.spot});

  final Spot spot;

  @override
  Widget build(BuildContext context) {
    // Filter sample comments for this specific spot
    final spotComments = sampleComments
        .where((c) => c.spotId == spot.id)
        .toList();

    return ListView(
      padding: AppSpacing.page,
      children: [
        // 1. Photo Banner with Fallback & Overlay Badges
        _buildPhotoHeader(context),
        const SizedBox(height: AppSpacing.md),

        // 2. Spot Details Card (Location, Author, Caption, Tags)
        _buildSpotInfoCard(context),
        const SizedBox(height: AppSpacing.md),

        // 3. Social Action Bar (Like, Save, Comment, Share)
        _buildSocialActionBar(context),
        const SizedBox(height: AppSpacing.lg),

        // 4. Comments Section & Mock Input Field
        _buildCommentsSection(context, spotComments),
      ],
    );
  }

  // --- Helper Widget 1: Photo Header ---
  Widget _buildPhotoHeader(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          _buildPhoto(context),
          if (spot.budgetLabel != null)
            Positioned(
              bottom: AppSpacing.sm,
              left: AppSpacing.sm,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: AppColors.midnightInk.withValues(alpha: 0.75),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      spot.budgetLabel!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhoto(BuildContext context) {
    if (spot.photoReference != null && spot.photoReference!.isNotEmpty) {
      if (spot.photoReference!.startsWith('http')) {
        return Image.network(
          spot.photoReference!,
          height: 240,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildFallback(context),
        );
      }
      return Image.asset(
        spot.photoReference!,
        height: 240,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildFallback(context),
      );
    }
    return _buildFallback(context);
  }

  Widget _buildFallback(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.softLavender,
            AppColors.paleCyan.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.explore_rounded,
              size: 160,
              color: AppColors.electricPurple.withValues(alpha: 0.08),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.85),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14A855F7),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.photo_camera_back_rounded,
                  size: 28,
                  color: AppColors.electricPurple,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Outspot place preview',
                style: TextStyle(
                  color: AppColors.slateGray.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Helper Widget 2: Spot Info Card ---
  Widget _buildSpotInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.softBorder),
        boxShadow: const [AppColors.subtleCardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location / Place Title
          if (spot.placeName != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 22,
                  color: AppColors.electricPurple,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    spot.placeName!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.midnightInk,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Author / Profile Row
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.softLavender,
                child: Text(
                  spot.author.username.characters.first.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.deepViolet,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spot.author.displayName ?? 'Unknown',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.midnightInk,
                    ),
                  ),
                  Text(
                    '@${spot.author.username}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.slateGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Full Caption (untruncated in detail view)
          Text(
            spot.caption,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.midnightInk.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),

          // Tags
          if (spot.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [for (final tag in spot.tags) AppTagChip(label: tag)],
            ),
          ],
        ],
      ),
    );
  }

  // --- Helper Widget 3: Social Action Bar ---
  Widget _buildSocialActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.softBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Like Action Button (Mock)
          _SocialActionButton(
            icon: Icons.favorite_border_rounded,
            label: '${spot.likeCount ?? 0}',
            onTap: () => _showMockNotice(context, 'Likes will sync in Phase 2'),
          ),

          // Save / Bookmark Button (Mock)
          _SocialActionButton(
            icon: Icons.bookmark_border_rounded,
            label: 'Save',
            onTap: () =>
                _showMockNotice(context, 'Saving will sync in Phase 2'),
          ),

          // Comment Action Button (Mock)
          _SocialActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Comment',
            onTap: () =>
                _showMockNotice(context, 'Comments will sync in Phase 2'),
          ),

          // Share Action Button (Mock)
          _SocialActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            onTap: () => _showMockNotice(context, 'Sharing available soon'),
          ),
        ],
      ),
    );
  }

  // Helper notice snackbar for mock actions
  void _showMockNotice(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- Helper Widget 4: Comments Section ---
  Widget _buildCommentsSection(BuildContext context, List<Comment> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Comments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.midnightInk,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.softLavender,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${comments.length}',
                style: const TextStyle(
                  color: AppColors.deepViolet,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // List of Comments or Empty Notice
        if (comments.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.softBorder),
            ),
            child: const Text(
              'No comments yet. Be the first to start the conversation!',
              style: TextStyle(color: AppColors.slateGray, fontSize: 13),
            ),
          )
        else
          Column(
            children: [
              for (final comment in comments)
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.softBorder),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.softLavender,
                        child: Text(
                          comment.author.username.characters.first
                              .toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.deepViolet,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@${comment.author.username}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: AppColors.midnightInk,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              comment.text,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.midnightInk,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

        const SizedBox(height: AppSpacing.md),

        // Mock Comment Input Box
        TextField(
          enabled: false, // Disabled in Phase 1
          decoration: InputDecoration(
            hintText: 'Comments will be enabled in Phase 2...',
            filled: true,
            fillColor: AppColors.surfaceWhite,
            prefixIcon: const Icon(Icons.mode_comment_outlined, size: 20),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.softBorder),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.softBorder),
            ),
          ),
        ),
      ],
    );
  }
}

// Sub-widget for social action items
class _SocialActionButton extends StatelessWidget {
  const _SocialActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.midnightInk),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.midnightInk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
