import 'package:flutter/material.dart';

import '../core/navigation/app_router.dart';
import '../core/navigation/app_routes.dart';

class OutspotApp extends StatelessWidget {
  const OutspotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outspot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.feed,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
