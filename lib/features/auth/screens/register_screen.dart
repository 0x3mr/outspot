import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_page_padding.dart';
import '../../../core/widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.isRegistering = true});

  final bool isRegistering;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _isRegistering = widget.isRegistering;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_isRegistering ? 'Create account' : 'Sign in')),
    body: AppPagePadding(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  _isRegistering ? 'Join Outspot' : 'Welcome back',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (_isRegistering) ...[
                  AppTextField(
                    label: 'Name',
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter your name'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                AppTextField(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || !value.contains('@')
                      ? 'Enter a valid email address'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Password',
                  obscureText: true,
                  validator: (value) => value == null || value.length < 8
                      ? 'Use at least 8 characters'
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: _isRegistering ? 'Create account' : 'Sign in',
                  onPressed: _continueToPreview,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () =>
                      setState(() => _isRegistering = !_isRegistering),
                  child: Text(
                    _isRegistering
                        ? 'Already have an account? Sign in'
                        : 'New to Outspot? Create an account',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  void _continueToPreview() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.feed,
      (route) => false,
    );
  }
}
