import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.validator,
  });

  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(40)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF6B6F76)),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              obscureText: obscureText,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: t.titleSmall,
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              validator: validator,
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}
