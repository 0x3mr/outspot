import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../data/fixtures/sample_data.dart';
import '../../../data/repositories/spot_provider.dart';
import '../../../models/profile.dart';
import '../../navigation/main_navigation_shell.dart';
import '../widgets/profile_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // The signed-in profile is mocked until auth lands in P2-02.
  Profile _profile = sampleProfile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<SpotProvider>();
      if (provider.spots.isEmpty && !provider.isLoading) provider.loadSpots();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SpotProvider>();
    return ProfileView(
      profile: _profile,
      spots: [
        for (final spot in provider.spots)
          if (spot.author.id == _profile.id) spot,
      ],
      isLoadingSpots: provider.isLoading,
      onEditProfile: _editProfile,
      onOpenSpot: (spot) =>
          Navigator.pushNamed(context, AppRoutes.spotDetail, arguments: spot),
      onCreateSpot: () => Navigator.pushNamed(context, AppRoutes.createSpot),
      onOpenSaved: _openSaved,
    );
  }

  void _openSaved() {
    if (MainNavigationShell.selectTab(
      context,
      MainNavigationShell.savedTabIndex,
    )) {
      return;
    }
    Navigator.pushNamed(context, AppRoutes.saved);
  }

  Future<void> _editProfile() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.editProfile,
      arguments: _profile,
    );
    if (!mounted || result is! Profile) return;
    setState(() => _profile = result);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Profile updated')));
  }
}
