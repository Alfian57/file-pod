import 'package:flutter/material.dart';

/// Reusable text input widget with integrated password visibility toggle.
/// Uses TextFormField directly to prevent keyboard dismissal on validation.
class AppInput extends StatefulWidget {
  const AppInput({
    super.key,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.controller,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final String hintText;
  final IconData icon;
  /// Set to true for password fields - will show eye toggle icon
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late final TextEditingController _internalController;
  bool _ownsController = false;
  
  /// Internal state for password visibility - prevents parent rebuild
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
      _ownsController = true;
    } else {
      _internalController = widget.controller!;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _internalController.dispose();
    super.dispose();
  }
  
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return TextFormField(
      controller: _internalController,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.disabled,
      style: t.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: t.titleSmall,
        prefixIcon: Icon(widget.icon, size: 22, color: const Color(0xFF6B6F76)),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: _toggleObscureText,
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF6B6F76),
                ),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withAlpha(40)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withAlpha(40)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF567DF4), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.withAlpha(150)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorStyle: t.bodySmall?.copyWith(color: Colors.red[700]),
      ),
    );
  }
}
