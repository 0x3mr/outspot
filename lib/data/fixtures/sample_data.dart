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
    likeCount: 24,
    createdAt: DateTime.utc(2026, 1, 3),
  ),
  Spot(
    id: 'spot-2',
    author: sampleProfile,
    caption: 'A quiet spot for your next outing.',
    placeName: 'Sample Garden',
    latitude: 30.0131,
    longitude: 31.2089,
    tags: ['outdoors'],
    budgetLabel: 'Free',
    likeCount: 42,
    createdAt: DateTime.utc(2026, 1, 2),
  ),
  Spot(
    id: 'spot-3',
    author: sampleProfile,
    caption:
        'An incredible rooftop viewpoint overlooking the city skyline with soft ambient lighting, cozy lounge pods, specialty drinks, and panoramic sunset views that stretch across the entire bay.',
    placeName: 'Neon Horizon Rooftop',
    latitude: 30.0500,
    longitude: 31.2400,
    tags: ['views', 'nightlife', 'aesthetic'],
    budgetLabel: r'$$$',
    likeCount: 128,
    createdAt: DateTime.utc(2026, 1, 1),
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
