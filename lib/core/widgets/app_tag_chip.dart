import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppTagChip extends StatelessWidget {
  const AppTagChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return Container(
        decoration: const ShapeDecoration(
          shape: StadiumBorder(),
          gradient: AppColors.primaryGradient,
        ),
        child: FilterChip(
          label: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          selected: true,
          onSelected: onSelected,
          showCheckmark: false,
          backgroundColor: Colors.transparent,
          selectedColor: Colors.transparent,
          side: BorderSide.none,
          shape: const StadiumBorder(),
        ),
      );
    }

    return FilterChip(
      label: Text(
        label,
        style: const TextStyle(
          color: AppColors.midnightInk,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      selected: false,
      onSelected: onSelected,
      showCheckmark: false,
      backgroundColor: AppColors.surfaceWhite,
      side: const BorderSide(color: AppColors.softBorder),
      shape: const StadiumBorder(),
    );
  }
}
