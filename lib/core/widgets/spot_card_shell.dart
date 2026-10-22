import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

class SpotCardShell extends StatelessWidget {
  const SpotCardShell({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: [AppColors.subtleCardShadow],
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.softBorder),
        ),
        color: AppColors.surfaceWhite,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.softLavender.withValues(alpha: 0.4),
          highlightColor: AppColors.softLavender.withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}
