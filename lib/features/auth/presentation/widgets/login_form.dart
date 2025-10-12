import 'package:file_pod/core/widgets/app_button.dart';
import 'package:file_pod/core/widgets/app_input.dart';
import 'package:flutter/material.dart';
import 'package:file_pod/theme.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppInput(
            hintText: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppInput(
            hintText: 'Password',
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffix: IconButton(
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF6B6F76),
              ),
            ),
            validator: (v) {
              return null;
            },
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: t.titleSmall?.copyWith(color: AppTheme.primary),
                ),
              ),
            ],
          ),

          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Login',
              icon: Icons.arrow_right_alt,
              iconOnRight: true,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Handle login
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
