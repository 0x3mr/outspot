import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/navigation/app_routes.dart';
import 'data/repositories/mock_spot_repository.dart';
import 'data/repositories/spot_provider.dart';
import 'data/repositories/spot_repository.dart';

void main() {
  runApp(
    Provider<SpotRepository>(
      create: (_) => MockSpotRepository(),
      child: ChangeNotifierProvider(
        create: (context) => SpotProvider(context.read<SpotRepository>()),
        child: const OutspotApp(),
      ),
    ),
  );
}

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
      routes: {
        AppRoutes.feed: (_) => const PlaceholderScreen(title: 'Feed'),
        AppRoutes.explore: (_) => const PlaceholderScreen(title: 'Explore'),
        AppRoutes.createSpot: (_) =>
            const PlaceholderScreen(title: 'Create Spot'),
        AppRoutes.profile: (_) => const PlaceholderScreen(title: 'Profile'),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.spotDetail) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const PlaceholderScreen(title: 'Spot Detail'),
          );
        }
        return null;
      },
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title screen')),
    );
  }
}
