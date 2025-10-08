import 'package:flutter/material.dart';

enum AppButtonType { primary, outlined }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.type = AppButtonType.primary,
    this.iconOnRight = false,
  });

  final String label;
  final void Function() onPressed;
  final IconData? icon;
  final AppButtonType type;
  final bool iconOnRight;

  @override
  Widget build(BuildContext context) {
    final isPrimary = type == AppButtonType.primary;
    final Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null && !iconOnRight) Icon(icon, size: 18),
        if (icon != null && !iconOnRight) const SizedBox(width: 8),
        Text(label),
        if (icon != null && iconOnRight) const SizedBox(width: 8),
        if (icon != null && iconOnRight) Icon(icon, size: 18),
      ],
    );

    if (isPrimary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: Theme.of(context).elevatedButtonTheme.style,
        child: child,
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: Theme.of(context).outlinedButtonTheme.style,
      child: child,
    );
  }
}
