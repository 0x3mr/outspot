import 'package:flutter/material.dart';

import '../../../models/spot.dart';

class SpotDetailView extends StatelessWidget {
  const SpotDetailView({super.key, required this.spot});

  final Spot spot;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          spot.placeName ?? 'Unknown place',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Text(spot.caption),
        const SizedBox(height: 12),
        Text('By @${spot.author.username}'),
        if (spot.budgetLabel != null) Text('Budget: ${spot.budgetLabel}'),
        if (spot.tags.isNotEmpty) Text('Tags: ${spot.tags.join(', ')}'),
      ],
    );
  }
}
