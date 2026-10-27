class AppRoutes {
  AppRoutes._();

  static const feed = '/';
  static const explore = '/explore';
  static const createSpot = '/create';
  static const createSpotDetails = '/create/details';
  static const createSpotReview = '/create/review';
  static const saved = '/saved';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const spotDetail = '/spot-detail';
  static const login = '/login';
  static const signIn = '/sign-in';
  static const register = '/register';

  static const titles = <String, String>{
    feed: 'Feed',
    explore: 'Explore',
    createSpot: 'Create Spot',
    createSpotDetails: 'Add details',
    createSpotReview: 'Review spot',
    saved: 'Saved',
    profile: 'Profile',
    editProfile: 'Edit profile',
    spotDetail: 'Spot Detail',
    login: 'Welcome',
    signIn: 'Sign in',
    register: 'Create account',
  };
}
