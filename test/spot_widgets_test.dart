import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outspot/data/fixtures/sample_data.dart';
import 'package:outspot/features/explore/widgets/spot_marker_preview.dart';
import 'package:outspot/features/feed/widgets/spot_card.dart';
import 'package:outspot/features/feed/widgets/spot_feed_list.dart';
import 'package:outspot/features/spot_detail/widgets/spot_detail_view.dart';

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
