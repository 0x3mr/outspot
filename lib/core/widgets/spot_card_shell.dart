import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class SpotCardShell extends StatelessWidget {
  const SpotCardShell({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: child,
      ),
    ),
  );
}
