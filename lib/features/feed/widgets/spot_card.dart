import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
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
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                _buildPhoto(context),
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        child: const Icon(
                          Icons.bookmark_border_rounded,
                          size: 19,
                          color: AppColors.midnightInk,
                        ),
                      ),
                    ),
                  ),
                ),
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
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: AppColors.midnightInk.withValues(
                              alpha: 0.75,
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            spot.budgetLabel!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (spot.placeName != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: AppColors.electricPurple,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    spot.placeName!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.midnightInk,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          Text(
            spot.caption,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.midnightInk.withValues(alpha: 0.88),
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: AppColors.softLavender,
                child: Text(
                  spot.author.username.characters.first.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.deepViolet,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '@${spot.author.username}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.slateGray,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    size: 16,
                    color: AppColors.electricPurple,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${spot.likeCount ?? 0}',
                    style: const TextStyle(
                      color: AppColors.midnightInk,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
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

  Widget _buildPhoto(BuildContext context) {
    if (spot.photoReference != null && spot.photoReference!.isNotEmpty) {
      if (spot.photoReference!.startsWith('http')) {
        return Image.network(
          spot.photoReference!,
          height: 175,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildFallback(context),
        );
      }
      return Image.asset(
        spot.photoReference!,
        height: 175,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildFallback(context),
      );
    }
    return _buildFallback(context);
  }

  Widget _buildFallback(BuildContext context) {
    return Container(
      height: 165,
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
            right: -15,
            bottom: -15,
            child: Icon(
              Icons.explore_rounded,
              size: 120,
              color: AppColors.electricPurple.withValues(alpha: 0.08),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.85),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14A855F7),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.photo_camera_back_rounded,
                  size: 24,
                  color: AppColors.electricPurple,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Outspot place preview',
                style: TextStyle(
                  color: AppColors.slateGray.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
