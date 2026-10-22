import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outspot/core/navigation/app_routes.dart';
import 'package:outspot/main.dart';

void main() {
  testWidgets('feed route opens by default', (tester) async {
    await tester.pumpWidget(const OutspotApp());

    expect(find.text('Feed screen'), findsOneWidget);
  });

  testWidgets('all registered routes open', (tester) async {
    await tester.pumpWidget(const OutspotApp());

    final routes = [
      AppRoutes.explore,
      AppRoutes.createSpot,
      AppRoutes.profile,
      AppRoutes.spotDetail,
    ];

    for (final route in routes) {
      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );

      navigator.pushNamed(route);
      await tester.pumpAndSettle();

      expect(find.byType(PlaceholderScreen), findsOneWidget);

      navigator.pop();
      await tester.pumpAndSettle();
    }
  });
}
