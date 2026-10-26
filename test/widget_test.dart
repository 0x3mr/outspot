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
    expect(find.textContaining('30.0370°'), findsOneWidget);

    await tester.tap(find.text('Confirm location'));
    await tester.pumpAndSettle();
    expect(find.text('Caption'), findsOneWidget);
    expect(find.textContaining('30.0370°'), findsOneWidget);
  });

  testWidgets('location selector retains coordinates when navigating back', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());
    await tester.tap(find.text('Explore the preview'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Create a spot'));
    await tester.pumpAndSettle();
    expect(find.textContaining('30.0370°'), findsOneWidget);

    await tester.tap(find.text('Confirm location'));
    await tester.pumpAndSettle();
    expect(find.text('Caption'), findsOneWidget);
    expect(find.textContaining('30.0370°'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(CreateSpotLocationScreen), findsOneWidget);
    expect(find.textContaining('30.0370°'), findsOneWidget);
  });

  testWidgets(
    'photo selection, required place name, and caption form validation',
    (tester) async {
      await tester.pumpWidget(_testApp());
      await tester.tap(find.text('Explore the preview'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Create a spot'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm location'));
      await tester.pumpAndSettle();

      // Verify missing-image state initially
      expect(find.text('No photo selected yet'), findsOneWidget);
      expect(find.text('Take Photo'), findsOneWidget);
      expect(find.text('Choose from Gallery'), findsOneWidget);

      // Select a photo and verify preview appears
      await tester.tap(find.text('Take Photo'));
      await tester.pumpAndSettle();
      expect(find.text('Photo ready to upload'), findsOneWidget);

      // Remove photo and verify return to empty state
      await tester.tap(find.byTooltip('Remove photo'));
      await tester.pumpAndSettle();
      expect(find.text('No photo selected yet'), findsOneWidget);

      // Enter caption only, leaving place name empty
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Caption'),
        'An awesome sunset view spot.',
      );
      await tester.pumpAndSettle();

      // Scroll down and tap preview without place name -> triggers required place name error
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Preview spot'));
      await tester.pumpAndSettle();
      expect(find.text('Add a name for your spot'), findsOneWidget);

      // Scroll back up to fill in required place name
      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Place name'),
        'Cairo Sky Garden',
      );
      await tester.pumpAndSettle();

      // Scroll down and preview succeeds
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Preview spot'));
      await tester.pumpAndSettle();
      expect(
        find.text('Your spot is ready for the next step.'),
        findsOneWidget,
      );

      // Test long caption limit (> 280 chars) disables submit
      final longCaption = 'A' * 285;
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Caption'),
        longCaption,
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('285 / 280'), findsOneWidget);
      final submitButton = find.widgetWithText(FilledButton, 'Preview spot');
      expect(tester.widget<FilledButton>(submitButton).enabled, isFalse);
    },
  );

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

    await tester.tap(find.text('Confirm location'));
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
    await tester.tap(find.text('Confirm location'));
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
