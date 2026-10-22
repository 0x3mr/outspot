import 'package:flutter/material.dart';

import '../../../models/spot.dart';

class SpotCard extends StatelessWidget {
  const SpotCard({super.key, required this.spot});

  final Spot spot;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spot.placeName ?? 'Unknown place',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(spot.caption),
            const SizedBox(height: 8),
            Text('@${spot.author.username}'),
          ],
        ),
      ),
    );
  }
}
