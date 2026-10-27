import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outspot/core/navigation/app_router.dart';
import 'package:outspot/data/repositories/mock_spot_repository.dart';
import 'package:outspot/data/repositories/spot_provider.dart';
import 'package:outspot/data/repositories/spot_repository.dart';
import 'package:outspot/features/profile/screens/profile_screen.dart';
import 'package:outspot/features/profile/widgets/profile_view.dart';
import 'package:outspot/models/profile.dart';
import 'package:outspot/models/spot.dart';
import 'package:provider/provider.dart';

void main() {
  group('ProfileView', () {
    testWidgets('shows identity, join date, and stats for many posts', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          ProfileView(
            profile: _profile,
            spots: [for (var i = 0; i < 5; i++) _spot('spot-$i', likes: 10)],
          ),
        ),
      );

      expect(find.text('Maya Hassan'), findsOneWidget);
      expect(find.text('@maya_h'), findsWidgets);
      expect(find.text('Joined March 2026'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Posts'), findsOneWidget);
      expect(find.text('50'), findsOneWidget);
      expect(find.text('Likes received'), findsOneWidget);
    });

    testWidgets('zero posts shows an empty state', (tester) async {
      var createTapped = false;
      await tester.pumpWidget(
        _wrap(
          ProfileView(
            profile: _profile,
            spots: const [],
            onCreateSpot: () => createTapped = true,
          ),
        ),
      );

      await tester.ensureVisible(find.text('Create a spot'));
      await tester.pumpAndSettle();
      expect(find.text('No spots yet'), findsOneWidget);
      await tester.tap(find.text('Create a spot'));
      expect(createTapped, isTrue);
    });

    testWidgets('missing avatar and bio fall back cleanly', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ProfileView(
            profile: Profile(id: 'p', username: 'no_extras'),
            spots: [],
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('no_extras'), findsOneWidget);
      expect(find.textContaining('Joined'), findsNothing);
    });

    testWidgets('long names and bios fit a narrow phone', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrap(
          ProfileView(
            profile: Profile(
              id: 'p',
              username: 'a_very_long_username_here',
              displayName: 'An Exceptionally Long Display Name ' * 3,
              bio: 'I love finding hidden places around the city. ' * 4,
              joinedAt: DateTime.utc(2026, 3, 2),
            ),
            spots: [_spot('spot-1')],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('Edit profile', () {
    testWidgets('save stays disabled until something changes', (tester) async {
      await _openEditProfile(tester);

      final save = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Save changes'),
      );
      expect(save.onPressed, isNull);
    });

    testWidgets('saved changes appear on the profile', (tester) async {
      await _openEditProfile(tester);

      await tester.enterText(_field('Display name'), 'Maya Explorer');
      await tester.enterText(_field('Bio'), 'Rooftops and riverside walks.');
      await tester.tap(find.text('Save changes'));
      await tester.pumpAndSettle();

      expect(find.text('Maya Explorer'), findsOneWidget);
      expect(find.text('Rooftops and riverside walks.'), findsOneWidget);
      expect(find.text('Profile updated'), findsOneWidget);
    });

    testWidgets('cancel discards edits', (tester) async {
      await _openEditProfile(tester);

      await tester.enterText(_field('Display name'), 'Changed name');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Changed name'), findsNothing);
      expect(find.text('Outspot Explorer'), findsOneWidget);
    });

    testWidgets('invalid username and long bio are rejected', (tester) async {
      await _openEditProfile(tester);

      await tester.enterText(_field('Username'), 'no spaces allowed');
      await tester.enterText(_field('Bio'), 'x' * 161);
      await tester.tap(find.text('Save changes'));
      await tester.pumpAndSettle();

      expect(
        find.text('Use 3-20 letters, numbers, or underscores'),
        findsOneWidget,
      );
      expect(find.text('Keep your bio under 160 characters'), findsOneWidget);
      expect(find.text('Edit profile'), findsWidgets);
    });
  });
}

final _profile = Profile(
  id: 'profile-maya',
  username: 'maya_h',
  displayName: 'Maya Hassan',
  bio: 'Weekend wanderer.',
  joinedAt: DateTime.utc(2026, 3, 2),
);

Spot _spot(String id, {int likes = 0}) => Spot(
  id: id,
  author: _profile,
  caption: 'Caption for $id',
  placeName: 'Place $id',
  likeCount: likes,
  createdAt: DateTime.utc(2026, 4, 1),
);

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

Finder _field(String label) => find.widgetWithText(TextFormField, label);

Future<void> _openEditProfile(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    Provider<SpotRepository>(
      create: (_) => MockSpotRepository(),
      child: ChangeNotifierProvider(
        create: (context) => SpotProvider(context.read<SpotRepository>()),
        child: const MaterialApp(
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: Scaffold(body: ProfileScreen()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Edit profile'));
  await tester.pumpAndSettle();
}
