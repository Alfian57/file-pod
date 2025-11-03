import 'package:flutter/material.dart';

class AppInput extends StatefulWidget {
  const AppInput({
    super.key,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.validator,
    this.controller,
  });

  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late final TextEditingController _internalController;
  bool _ownsController = false;
  final FocusNode _focusNode = FocusNode();

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
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return FormField<String>(
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        final hasError =
            state.hasError && (state.errorText?.isNotEmpty ?? false);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: hasError
                      ? Colors.red.withValues(alpha: 0.6)
                      : Colors.grey.withAlpha(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Row(
                children: [
                  Icon(widget.icon, size: 22, color: const Color(0xFF6B6F76)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (!_focusNode.hasFocus) _focusNode.requestFocus();
                      },
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _internalController,
                        obscureText: widget.obscureText,
                        keyboardType: widget.keyboardType,
                        onChanged: state.didChange,
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: t.titleSmall,
                          border: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (widget.suffix != null) widget.suffix!,
                ],
              ),
            ),
            if (hasError) const SizedBox(height: 6),
            if (hasError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  state.errorText!,
                  style: t.bodySmall?.copyWith(color: Colors.red[700]),
                ),
              ),
          ],
        );
      },
    );
  }
}
