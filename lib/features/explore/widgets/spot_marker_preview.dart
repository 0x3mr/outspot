import 'package:flutter/material.dart';

import '../../../models/spot.dart';

class SpotMarkerPreview extends StatelessWidget {
  const SpotMarkerPreview({super.key, required this.spot});

  final Spot spot;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(spot.placeName ?? 'Unknown place'),
            Text(spot.caption),
          ],
        ),
      ),
    );
  }
}
