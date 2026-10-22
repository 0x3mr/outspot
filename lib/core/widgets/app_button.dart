import 'package:flutter/material.dart';

enum AppButtonStyle { primary, secondary }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = icon == null
        ? FilledButton(onPressed: onPressed, child: Text(label))
        : FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
          );
    final styledButton = style == AppButtonStyle.primary
        ? button
        : (icon == null
              ? OutlinedButton(onPressed: onPressed, child: Text(label))
              : OutlinedButton.icon(
                  onPressed: onPressed,
                  icon: Icon(icon),
                  label: Text(label),
                ));

    return SizedBox(
      width: expand ? double.infinity : null,
      height: 48,
      child: styledButton,
    );
  }
}
