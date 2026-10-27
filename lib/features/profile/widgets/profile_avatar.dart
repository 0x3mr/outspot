import 'package:flutter/material.dart';

import '../../../models/profile.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.profile, this.radius = 38});

  final Profile profile;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
    final colors = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.secondaryContainer,
      foregroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
      onForegroundImageError: hasAvatar ? (_, _) {} : null,
      child: Icon(Icons.person, size: radius, color: colors.primary),
    );
  }
}
