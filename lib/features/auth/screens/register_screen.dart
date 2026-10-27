import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_page_padding.dart';
import '../../../core/widgets/app_state_widgets.dart';
import '../../../core/widgets/app_text_field.dart';
import '../auth_validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.isRegistering = true});

  final bool isRegistering;

  // Stands in for the auth request until Supabase auth lands in P2-02.1.
  static const mockSubmitDelay = Duration(milliseconds: 600);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  late bool _isRegistering = widget.isRegistering;
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_isRegistering ? 'Create account' : 'Sign in')),
    body: AppPagePadding(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: ListView(
                children: [
                  Text(
                    _isRegistering ? 'Join Outspot' : 'Welcome back',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (_isRegistering) ...[
                    const AppTextField(
                      label: 'Name',
                      textInputAction: TextInputAction.next,
                      autofillHints: [AutofillHints.name],
                      validator: AuthValidators.name,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const AppTextField(
                      label: 'Username',
                      hintText: 'Shown on your public profile',
                      textInputAction: TextInputAction.next,
                      autofillHints: [AutofillHints.newUsername],
                      validator: AuthValidators.username,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  const AppTextField(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: [AutofillHints.email],
                    validator: AuthValidators.email,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: _isRegistering
                        ? TextInputAction.next
                        : TextInputAction.done,
                    autofillHints: [
                      _isRegistering
                          ? AutofillHints.newPassword
                          : AutofillHints.password,
                    ],
                    validator: _isRegistering
                        ? AuthValidators.newPassword
                        : AuthValidators.signInPassword,
                    suffixIcon: IconButton(
                      tooltip: _obscurePassword
                          ? 'Show password'
                          : 'Hide password',
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  if (_isRegistering) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Confirm password',
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      validator: (value) => AuthValidators.confirmPassword(
                        value,
                        _passwordController.text,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  AppSubmitButton(
                    label: _isRegistering ? 'Create account' : 'Sign in',
                    isSubmitting: _isSubmitting,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: _isSubmitting ? null : _toggleMode,
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
    ),
  );

  void _toggleMode() => setState(() {
    _isRegistering = !_isRegistering;
    _formKey.currentState?.reset();
    _passwordController.clear();
  });

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(RegisterScreen.mockSubmitDelay);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.feed,
      (route) => false,
    );
  }
}
