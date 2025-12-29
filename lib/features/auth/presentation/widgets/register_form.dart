import 'package:file_pod/core/configs/router-configs/route_names.dart';
import 'package:file_pod/core/widgets/ui/app_button.dart';
import 'package:file_pod/core/widgets/ui/app_input.dart';
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

    ref.listen(authControllerProvider, (prev, next) {
      // Show error snackbar only when error first appears
      if (next.error != null && prev?.error != next.error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }

      // Navigate on successful registration
      if (prev?.isLoading == true && !next.isLoading && next.error == null) {
        if (!mounted) return;
        // Clear any existing error snackbar first
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        context.goNamed(RouteNames.login);
      }
    });

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          AppInput(
            hintText: 'Full Name',
            icon: Icons.person_outline,
            controller: _nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
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
            textInputAction: TextInputAction.next,
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
            isPassword: true,
            textInputAction: TextInputAction.next,
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
            isPassword: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSubmit(),
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
