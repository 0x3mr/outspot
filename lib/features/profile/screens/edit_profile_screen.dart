import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_page_padding.dart';
import '../../../core/widgets/app_state_widgets.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/profile.dart';
import '../../auth/auth_validators.dart';
import '../widgets/profile_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final Profile profile;

  static const maxBioLength = 160;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _displayNameController = TextEditingController(
    text: widget.profile.displayName ?? '',
  );
  late final _usernameController = TextEditingController(
    text: widget.profile.username,
  );
  late final _bioController = TextEditingController(
    text: widget.profile.bio ?? '',
  );
  late String? _avatarUrl = widget.profile.avatarUrl;

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  bool get _hasChanges =>
      _displayNameController.text.trim() !=
          (widget.profile.displayName ?? '') ||
      _usernameController.text.trim() != widget.profile.username ||
      _bioController.text.trim() != (widget.profile.bio ?? '') ||
      _avatarUrl != widget.profile.avatarUrl;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = _avatarUrl != null && _avatarUrl!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: AppPagePadding(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: ProfileAvatar(
                      profile: Profile(
                        id: widget.profile.id,
                        username: widget.profile.username,
                        avatarUrl: _avatarUrl,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () => _showNotice(
                          'Photo uploads will be available in Phase 2.',
                        ),
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: const Text('Change photo'),
                      ),
                      if (hasAvatar)
                        TextButton(
                          onPressed: () => setState(() => _avatarUrl = null),
                          child: const Text('Remove photo'),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Display name',
                    controller: _displayNameController,
                    textInputAction: TextInputAction.next,
                    validator: AuthValidators.name,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Username',
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    validator: AuthValidators.username,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Bio',
                    hintText: 'Tell people what kind of places you share',
                    controller: _bioController,
                    maxLines: 4,
                    validator: _validateBio,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_bioController.text.trim().length}'
                      '/${EditProfileScreen.maxBioLength}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppSubmitButton(
                    label: 'Save changes',
                    enabled: _hasChanges,
                    onPressed: _save,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: 'Cancel',
                    style: AppButtonStyle.secondary,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateBio(String? value) =>
      (value?.trim().length ?? 0) > EditProfileScreen.maxBioLength
      ? 'Keep your bio under ${EditProfileScreen.maxBioLength} characters'
      : null;

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final bio = _bioController.text.trim();
    Navigator.pop(
      context,
      Profile(
        id: widget.profile.id,
        username: _usernameController.text.trim(),
        displayName: _displayNameController.text.trim(),
        avatarUrl: _avatarUrl,
        bio: bio.isEmpty ? null : bio,
        joinedAt: widget.profile.joinedAt,
      ),
    );
  }

  void _showNotice(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
