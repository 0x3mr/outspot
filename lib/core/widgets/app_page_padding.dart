import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AppPagePadding extends StatelessWidget {
  const AppPagePadding({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) =>
      Padding(padding: padding ?? AppSpacing.page, child: child);
}
