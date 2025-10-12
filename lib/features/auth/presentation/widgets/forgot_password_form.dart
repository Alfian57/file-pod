import 'package:file_pod/core/widgets/app_button.dart';
import 'package:file_pod/core/widgets/app_input.dart';
import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppInput(
            hintText: 'Enter your email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              return null;
            },
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Send Reset Link',
              icon: Icons.arrow_right_alt,
              iconOnRight: true,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Handle forgot password
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
