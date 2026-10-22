import 'package:flutter/material.dart';

import '../../features/shared/feature_placeholder_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<void> onGenerateRoute(RouteSettings settings) {
    final title = AppRoutes.titles[settings.name];
    if (title == null) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const FeaturePlaceholderScreen(
          title: 'Not found',
          message: 'The requested screen does not exist.',
        ),
      );
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => FeaturePlaceholderScreen(title: title),
    );
  }
}
