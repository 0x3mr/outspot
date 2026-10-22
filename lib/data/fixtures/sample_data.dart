import '../../models/comment.dart';
import '../../models/profile.dart';
import '../../models/spot.dart';

const sampleProfile = Profile(
  id: 'profile-1',
  username: 'outspot_user',
  displayName: 'Outspot Explorer',
);

final sampleSpots = <Spot>[
  Spot(
    id: 'spot-1',
    author: sampleProfile,
    caption: 'A great place to discover and share.',
    placeName: 'Sample Cafe',
    latitude: 30.0444,
    longitude: 31.2357,
    tags: ['cafe', 'discover'],
    budgetLabel: 'Budget friendly',
    createdAt: DateTime.utc(2026, 1, 1),
  ),
  Spot(
    id: 'spot-2',
    author: sampleProfile,
    caption: 'A quiet spot for your next outing.',
    placeName: 'Sample Garden',
    latitude: 30.0131,
    longitude: 31.2089,
    tags: ['outdoors'],
    createdAt: DateTime.utc(2026, 1, 2),
  ),
];

final sampleComments = <Comment>[
  Comment(
    id: 'comment-1',
    spotId: 'spot-1',
    author: sampleProfile,
    text: 'Adding this to my list!',
    createdAt: DateTime.utc(2026, 1, 3),
  ),
];
