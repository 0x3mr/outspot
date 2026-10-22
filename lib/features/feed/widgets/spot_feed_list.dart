import 'package:flutter/material.dart';

import '../../../models/spot.dart';
import 'spot_card.dart';

class SpotFeedList extends StatelessWidget {
  const SpotFeedList({super.key, required this.spots});

  final List<Spot> spots;

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return const Center(child: Text('No spots yet'));
    }

    return ListView.builder(
      itemCount: spots.length,
      itemBuilder: (context, index) => SpotCard(spot: spots[index]),
    );
  }
}
