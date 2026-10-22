import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outspot/data/fixtures/sample_data.dart';
import 'package:outspot/features/explore/widgets/spot_marker_preview.dart';
import 'package:outspot/features/feed/widgets/spot_card.dart';
import 'package:outspot/features/feed/widgets/spot_feed_list.dart';
import 'package:outspot/features/spot_detail/widgets/spot_detail_view.dart';
import 'package:outspot/models/profile.dart';
import 'package:outspot/models/spot.dart';

void main() {
  testWidgets('feed list shows an empty state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SpotFeedList(spots: [])),
      ),
    );

    expect(find.text('No spots yet'), findsOneWidget);
  });

  testWidgets('feed list renders fixture spots', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpotFeedList(spots: sampleSpots)),
      ),
    );

    expect(find.text('Sample Cafe'), findsOneWidget);
    expect(find.text('Sample Garden'), findsOneWidget);
    expect(find.byType(SpotCard), findsNWidgets(2));
  });

  testWidgets('renders three sample posts in newest-first order', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final spots = List<Spot>.from(sampleSpots)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpotFeedList(spots: spots)),
      ),
    );

    expect(spots.length, 3);
    expect(find.byType(SpotCard), findsNWidgets(3));
    final firstCard = tester.widget<SpotCard>(find.byType(SpotCard).first);
    expect(firstCard.spot.id, 'spot-1');
    expect(find.text('Sample Cafe'), findsOneWidget);
  });

  testWidgets('long captions are handled neatly without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final longSpot = Spot(
      id: 'long-caption-spot',
      author: const Profile(
        id: 'u1',
        username: 'tester',
        displayName: 'Tester',
      ),
      placeName: 'Wordy Place',
      caption:
          'This is an exceptionally long caption written to thoroughly verify that the SpotCard widget '
          'clamps and truncates multi-line content with ellipsis rather than overflowing outside its parent container bounds. '
          'It continues describing wonderful sights, sounds, food, atmosphere, and amenities for several sentences.',
      createdAt: DateTime.utc(2026, 1, 1),
      likeCount: 99,
      tags: const ['long', 'caption', 'test'],
      budgetLabel: r'$$$$',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: SpotCard(spot: longSpot)),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Wordy Place'), findsOneWidget);
    expect(find.text('99'), findsOneWidget);
  });

  testWidgets('renders image fallback when photoReference is null or empty', (
    tester,
  ) async {
    final spotNoPhoto = Spot(
      id: 'no-photo-spot',
      author: const Profile(
        id: 'u1',
        username: 'photoless',
        displayName: 'Photoless',
      ),
      placeName: 'Placeholder Spot',
      caption:
          'Testing the fallback container when no photo reference is provided.',
      createdAt: DateTime.utc(2026, 1, 1),
      photoReference: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpotCard(spot: spotNoPhoto)),
      ),
    );

    expect(find.text('Outspot place preview'), findsOneWidget);
    expect(find.byIcon(Icons.photo_camera_back_rounded), findsOneWidget);
  });

  testWidgets('spot detail renders a fixture', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpotDetailView(spot: sampleSpots.first)),
      ),
    );

    expect(find.text('Sample Cafe'), findsOneWidget);
    expect(find.text(sampleSpots.first.caption), findsOneWidget);
  });

  testWidgets('marker preview renders a fixture', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpotMarkerPreview(spot: sampleSpots.first)),
      ),
    );

    expect(find.text('Sample Cafe'), findsOneWidget);
    expect(find.text(sampleSpots.first.caption), findsOneWidget);
  });
}
