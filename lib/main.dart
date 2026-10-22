import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/outspot_app.dart';
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
