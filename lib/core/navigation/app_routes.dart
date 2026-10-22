class AppRoutes {
  AppRoutes._();

  static const feed = '/';
  static const explore = '/explore';
  static const createSpot = '/create';
  static const profile = '/profile';
  static const spotDetail = '/spot-detail';

  static const titles = <String, String>{
    feed: 'Feed',
    explore: 'Explore',
    createSpot: 'Create Spot',
    profile: 'Profile',
    spotDetail: 'Spot Detail',
  };
}
