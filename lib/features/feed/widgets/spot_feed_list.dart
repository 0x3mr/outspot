import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_state_widgets.dart';
import '../../../models/spot.dart';
import 'spot_card.dart';

class SpotFeedList extends StatelessWidget {
  const SpotFeedList({super.key, required this.spots});

  final List<Spot> spots;

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return const AppEmptyState(
        title: 'No spots yet',
        message: 'Check back later or create the first spot in your area.',
        icon: Icons.place_outlined,
      );
    }

    return ListView.builder(
      padding: AppSpacing.pageFor(MediaQuery.sizeOf(context).width),
      itemCount: spots.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: SpotCard(
          spot: spots[index],
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.spotDetail,
            arguments: spots[index],
          ),
        ),
      ),
    );
  }
}
