import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outspot/app/outspot_app.dart';
import 'package:outspot/core/navigation/app_router.dart';
import 'package:outspot/data/repositories/mock_spot_repository.dart';
import 'package:outspot/data/repositories/spot_provider.dart';
import 'package:outspot/data/repositories/spot_repository.dart';
import 'package:outspot/features/saved/screens/saved_screen.dart';
import 'package:outspot/models/spot.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('one saved spot renders as a spot card', (tester) async {
    await tester.pumpWidget(
      _savedApp(MockSpotRepository(savedSpotIds: {'spot-1'})),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sample Cafe'), findsOneWidget);
    expect(find.text('Sample Garden'), findsNothing);
  });

  testWidgets('several saved spots render newest first', (tester) async {
    await tester.pumpWidget(
      _savedApp(MockSpotRepository(savedSpotIds: {'spot-1', 'spot-2'})),
    );
    await tester.pumpAndSettle();

    final cafe = tester.getTopLeft(find.text('Sample Cafe'));
    final garden = tester.getTopLeft(find.text('Sample Garden'));
    expect(cafe.dy, lessThan(garden.dy));
  });

  testWidgets('empty collection explains how to save spots', (tester) async {
    await tester.pumpWidget(_savedApp(MockSpotRepository(savedSpotIds: {})));
    await tester.pumpAndSettle();

    expect(find.text('Your saved spots live here'), findsOneWidget);
    expect(find.textContaining('only visible to you'), findsOneWidget);
  });

  testWidgets('load failure offers a retry', (tester) async {
    final repository = _FlakyRepository();
    await tester.pumpWidget(_savedApp(repository));
    await tester.pumpAndSettle();

    expect(find.text('Your saved spots could not be loaded.'), findsOneWidget);
    repository.fail = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Sample Garden'), findsOneWidget);
  });

  testWidgets('opening a saved spot reaches its detail', (tester) async {
    await tester.pumpWidget(
      _savedApp(MockSpotRepository(savedSpotIds: {'spot-2'})),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sample Garden'));
    await tester.pumpAndSettle();

    expect(find.text('A quiet spot for your next outing.'), findsOneWidget);
  });

  testWidgets('profile links to saved places and back to the feed', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _withProviders(MockSpotRepository(), const OutspotApp()),
    );
    await tester.tap(find.text('Explore the preview'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Saved places'));
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsWidgets);
    expect(find.text('Neon Horizon Rooftop'), findsOneWidget);
    expect(find.text('Saved places'), findsNothing);

    await tester.tap(find.text('Feed'));
    await tester.pumpAndSettle();
    expect(find.text('Sample Cafe'), findsOneWidget);
  });
}

class _FlakyRepository extends MockSpotRepository {
  bool fail = true;

  @override
  Future<List<Spot>> listSavedSpots() async {
    if (fail) throw StateError('offline');
    return super.listSavedSpots();
  }
}

Widget _withProviders(SpotRepository repository, Widget child) =>
    Provider<SpotRepository>.value(
      value: repository,
      child: ChangeNotifierProvider(
        create: (context) => SpotProvider(context.read<SpotRepository>()),
        child: child,
      ),
    );

Widget _savedApp(SpotRepository repository) => _withProviders(
  repository,
  const MaterialApp(
    onGenerateRoute: AppRouter.onGenerateRoute,
    home: Scaffold(body: SavedScreen()),
  ),
);
