import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outspot/core/theme/app_spacing.dart';
import 'package:outspot/data/fixtures/sample_data.dart';
import 'package:outspot/features/auth/screens/auth_entry_screen.dart';
import 'package:outspot/features/feed/widgets/spot_card.dart';
import 'package:outspot/features/feed/widgets/spot_feed_list.dart';
import 'package:outspot/features/profile/widgets/profile_view.dart';
import 'package:outspot/features/spot_detail/widgets/spot_detail_view.dart';

void main() {
  test('page padding keeps the phone gutter and centres wide content', () {
    expect(AppSpacing.pageFor(375).left, AppSpacing.md);
    expect(AppSpacing.pageFor(768).left, 84);
    expect(AppSpacing.pageFor(768).right, 84);
    expect(AppSpacing.pageFor(768).top, AppSpacing.md);
  });

  for (final (name, screen) in [
    ('feed list', SpotFeedList(spots: sampleSpots)),
    ('profile', ProfileView(profile: sampleProfile, spots: sampleSpots)),
  ]) {
    testWidgets('$name cards are capped and centred on a tablet', (
      tester,
    ) async {
      await _pumpAt(tester, const Size(768, 1024), screen);

      final card = tester.getRect(find.byType(SpotCard).first);
      expect(card.width, AppSpacing.maxContentWidth);
      expect(card.center.dx, 384);
    });

    testWidgets('$name cards keep the phone gutter', (tester) async {
      await _pumpAt(tester, const Size(375, 812), screen);

      final card = tester.getRect(find.byType(SpotCard).first);
      expect(card.left, AppSpacing.md);
      expect(card.width, 375 - 2 * AppSpacing.md);
    });
  }

  testWidgets('welcome screen fits a landscape phone', (tester) async {
    await _pumpAt(tester, const Size(800, 360), const AuthEntryScreen());

    expect(tester.takeException(), isNull);
    expect(find.text('Explore the preview'), findsOneWidget);
  });

  testWidgets('spot detail content is capped on a tablet', (tester) async {
    await _pumpAt(
      tester,
      const Size(768, 1024),
      SpotDetailView(spot: sampleSpots.first),
    );

    final title = tester.getRect(find.text('Sample Cafe').first);
    expect(title.left, greaterThanOrEqualTo(84));
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpAt(WidgetTester tester, Size size, Widget child) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
}
