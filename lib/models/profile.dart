class Profile {
  const Profile({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.joinedAt,
  });

  final String id;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final DateTime? joinedAt;
}
