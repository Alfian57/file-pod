import 'package:file_pod/core/widgets/app_button.dart';
import 'package:file_pod/core/widgets/app_input.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppInput(
            hintText: 'Full Name',
            icon: Icons.person_outline,
            keyboardType: TextInputType.name,
            validator: (v) {
              return null;
            },
          ),

          const SizedBox(height: 14),

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
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'Minimum 6 characters';
              return null;
            },
          ),

          const SizedBox(height: 14),

          AppInput(
            hintText: 'Confirm Password',
            icon: Icons.lock_outline,
            obscureText: _obscureConfirm,
            suffix: IconButton(
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF6B6F76),
              ),
            ),
            validator: (v) {
              return null;
            },
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Create Account',
              icon: Icons.arrow_forward_rounded,
              iconOnRight: true,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Handle register
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
