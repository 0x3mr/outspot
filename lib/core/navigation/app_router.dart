import 'package:flutter/material.dart';

import '../../features/auth/screens/auth_entry_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/create_spot/screens/create_spot_details_screen.dart';
import '../../features/create_spot/screens/create_spot_location_screen.dart';
import '../../features/create_spot/screens/create_spot_review_screen.dart';
import '../../features/navigation/main_navigation_shell.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/shared/feature_placeholder_screen.dart';
import '../../features/spot_detail/widgets/spot_detail_view.dart';
import '../../models/profile.dart';
import '../../models/spot.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<void> onGenerateRoute(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      AppRoutes.login => const AuthEntryScreen(),
      AppRoutes.signIn => const RegisterScreen(isRegistering: false),
      AppRoutes.register => const RegisterScreen(),
      AppRoutes.feed => const MainNavigationShell(),
      AppRoutes.explore => const MainNavigationShell(initialIndex: 1),
      AppRoutes.createSpot => const CreateSpotLocationScreen(),
      AppRoutes.createSpotDetails => const CreateSpotDetailsScreen(),
      AppRoutes.createSpotReview
          when settings.arguments is CreateSpotReviewArgs =>
        CreateSpotReviewScreen(
          args: settings.arguments! as CreateSpotReviewArgs,
        ),
      AppRoutes.saved => const MainNavigationShell(initialIndex: 2),
      AppRoutes.profile => const MainNavigationShell(initialIndex: 3),
      AppRoutes.editProfile when settings.arguments is Profile =>
        EditProfileScreen(profile: settings.arguments! as Profile),
      AppRoutes.spotDetail when settings.arguments is Spot => SpotDetailPage(
        spot: settings.arguments! as Spot,
      ),
      AppRoutes.spotDetail => const FeaturePlaceholderScreen(
        title: 'Spot not found',
        message: 'Return to the feed and choose a spot to view its details.',
      ),
      _ => const FeaturePlaceholderScreen(
        title: 'Page not found',
        message: 'This page is not available.',
      ),
    };

    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }
}

class SpotDetailPage extends StatelessWidget {
  const SpotDetailPage({super.key, required this.spot});

  final Spot spot;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(spot.placeName ?? 'Spot details')),
    body: SpotDetailView(spot: spot),
  );
}
