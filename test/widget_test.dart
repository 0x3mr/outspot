import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outspot/app/outspot_app.dart';
import 'package:outspot/core/navigation/app_routes.dart';
import 'package:outspot/data/repositories/mock_spot_repository.dart';
import 'package:outspot/data/repositories/spot_provider.dart';
import 'package:outspot/data/repositories/spot_repository.dart';
import 'package:outspot/features/create_spot/screens/create_spot_location_screen.dart';
import 'package:outspot/features/navigation/main_navigation_shell.dart';
import 'package:outspot/features/shared/feature_placeholder_screen.dart';
import 'package:outspot/models/profile.dart';
import 'package:outspot/models/spot.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('signed-out users start outside the main navigation', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());

    expect(find.text('Find places worth sharing.'), findsOneWidget);
    expect(find.byType(MainNavigationShell), findsNothing);

    await tester.tap(find.text('Explore the preview'));
    await tester.pumpAndSettle();

    expect(find.byType(MainNavigationShell), findsOneWidget);
    expect(find.text('Feed'), findsWidgets);
  });

  testWidgets('account routes stay outside the main tab shell', (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();

    expect(find.text('Join Outspot'), findsOneWidget);
    expect(find.byType(MainNavigationShell), findsNothing);

    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your name'), findsOneWidget);
    expect(find.byType(MainNavigationShell), findsNothing);
  });

  testWidgets('sign in route stays outside the main tab shell', (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byType(MainNavigationShell), findsNothing);
  });

  testWidgets('main destinations switch without replacing the shell', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());
    await tester.tap(find.text('Explore the preview'));
    await tester.pumpAndSettle();

    final shell = find.byType(MainNavigationShell);
    final shellStateBefore = tester.state(shell);

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(find.text('Find a spot nearby'), findsOneWidget);

    await tester.tap(find.text('Saved').last);
    await tester.pumpAndSettle();
    expect(find.text('Your saved spots live here'), findsOneWidget);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    expect(find.text('Outspot Explorer'), findsOneWidget);
    expect(tester.state(shell), same(shellStateBefore));
  });

  testWidgets('central create action starts with location selection', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());
    await tester.tap(find.text('Explore the preview'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Create a spot'));
    await tester.pumpAndSettle();
    expect(find.byType(CreateSpotLocationScreen), findsOneWidget);
    expect(find.text('Choose a location'), findsOneWidget);

    await tester.tap(find.text('Tap to place a pin'));
    await tester.pumpAndSettle();
    expect(find.text('Downtown Cairo'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Caption'), findsOneWidget);
  });

  testWidgets(
    'feed cards open their matching detail and back returns to feed',
    (tester) async {
      await tester.pumpWidget(_testApp());
      await tester.tap(find.text('Explore the preview'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sample Cafe'));
      await tester.pumpAndSettle();
      expect(find.text('A great place to discover and share.'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(MainNavigationShell), findsOneWidget);
      expect(find.text('Sample Cafe'), findsOneWidget);
    },
  );

  testWidgets('navigation and create flow fit a narrow phone screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_testApp());
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Explore the preview'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Create a spot'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Tap to place a pin'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('main navigation and create screens fit a larger phone screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_testApp());
    await tester.tap(find.text('Explore the preview'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Create a spot'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tap to place a pin'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('registered standalone routes still resolve safely', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));

    navigator.pushNamed(
      AppRoutes.spotDetail,
      arguments: Spot(
        id: 'route-test-spot',
        author: _routeTestProfile,
        caption: 'A route test spot',
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('A route test spot'), findsOneWidget);

    navigator.pop();
    await tester.pumpAndSettle();
    navigator.pushNamed('/unknown');
    await tester.pumpAndSettle();
    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
  });
}

Widget _testApp() => Provider<SpotRepository>(
  create: (_) => MockSpotRepository(),
  child: ChangeNotifierProvider(
    create: (context) => SpotProvider(context.read<SpotRepository>()),
    child: const OutspotApp(),
  ),
);

const _routeTestProfile = Profile(
  id: 'route-test-profile',
  username: 'route_test',
  displayName: 'Route test',
);
