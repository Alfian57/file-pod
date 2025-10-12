import 'package:file_pod/core/configs/router-configs/route_names.dart';
import 'package:file_pod/core/widgets/app_button.dart';
import 'package:file_pod/core/widgets/app_input.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:file_pod/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_pod/features/auth/presentation/controllers/auth_controller.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final res = await ref
          .read(authControllerProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);

      res.fold(
        (err) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err))),
        (_) => context.goNamed(RouteNames.storage),
      );
    }
  }

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
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppInput(
            hintText: 'Password',
            icon: Icons.lock_outline,
            controller: _passwordController,
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
              return null;
            },
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () => context.pushNamed(RouteNames.forgotPassword),
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
              onPressed: onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
