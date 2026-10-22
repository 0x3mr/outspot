import 'package:flutter/material.dart';

import '../core/navigation/app_router.dart';
import '../core/navigation/app_routes.dart';
import '../core/theme/app_theme.dart';

class OutspotApp extends StatelessWidget {
  const OutspotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outspot',
      theme: AppTheme.light,
      initialRoute: AppRoutes.login,
      onGenerateInitialRoutes: (initialRoute) => [
        AppRouter.onGenerateRoute(RouteSettings(name: initialRoute)),
      ],
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
