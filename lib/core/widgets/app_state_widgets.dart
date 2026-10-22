import 'package:flutter/material.dart';

import 'app_button.dart';
import 'app_page_padding.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.explore_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => AppPagePadding(
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 44, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 20),
            AppButton(label: actionLabel!, onPressed: onAction, expand: false),
          ],
        ],
      ),
    ),
  );
}

class AppErrorState extends StatelessWidget {
  const AppErrorState({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => AppEmptyState(
    title: 'Something went wrong',
    message: message,
    icon: Icons.cloud_off_outlined,
    actionLabel: onRetry == null ? null : 'Try again',
    onAction: onRetry,
  );
}

class AppInlineValidationMessage extends StatelessWidget {
  const AppInlineValidationMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Text(
      message,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
    ),
  );
}

class AppSubmitButton extends StatelessWidget {
  const AppSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSubmitting = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isSubmitting;
  final bool enabled;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 48,
    child: FilledButton(
      onPressed: enabled && !isSubmitting ? onPressed : null,
      child: isSubmitting
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    ),
  );
}
