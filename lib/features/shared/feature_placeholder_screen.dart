import 'package:flutter/material.dart';

import '../../core/widgets/app_state_widgets.dart';

class FeaturePlaceholderScreen extends StatelessWidget {
  const FeaturePlaceholderScreen({
    super.key,
    required this.title,
    this.message,
  });

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: AppEmptyState(
        title: title,
        message: message ?? '$title is not available yet.',
        icon: Icons.hourglass_empty,
      ),
    );
  }
}
