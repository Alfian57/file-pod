import 'package:file_pod/core/configs/router-configs/route_names.dart';
import 'package:file_pod/core/widgets/app_button.dart';
import 'package:file_pod/core/widgets/app_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_pod/features/auth/presentation/controllers/auth_controller.dart';
import 'package:file_pod/features/auth/domain/entities/user_entity.dart';
import 'package:go_router/go_router.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final user = UserEntity(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      ref.read(authControllerProvider.notifier).register(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    showSnackBar(String text, bool isError) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: isError ? theme.colorScheme.error : null,
        ),
      );
    }

    ref.listen(authControllerProvider, (prev, next) {
      if (next.error != null) {
        showSnackBar(next.error!, true);
      }

      if (prev?.isLoading == true && !next.isLoading && next.error == null) {
        showSnackBar('Registration successful', false);
        context.pushNamed(RouteNames.login);
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppInput(
            hintText: 'Full Name',
            icon: Icons.person_outline,
            controller: _nameController,
            keyboardType: TextInputType.name,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Name is required';
              return null;
            },
          ),

          const SizedBox(height: 14),

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
              if (v.length < 6) return 'Minimum 6 characters';
              return null;
            },
          ),

          const SizedBox(height: 14),

          AppInput(
            hintText: 'Confirm Password',
            icon: Icons.lock_outline,
            controller: _confirmController,
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
              if (v == null || v.isEmpty) {
                return 'Please confirm password';
              }
              if (v != _passwordController.text) {
                return 'Passwords do not match';
              }
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
              onPressed: onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
