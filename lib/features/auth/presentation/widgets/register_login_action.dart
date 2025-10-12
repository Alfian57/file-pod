import 'package:flutter/material.dart';
import 'package:file_pod/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:file_pod/core/configs/router-configs/route_names.dart';

class RegisterLoginAction extends StatelessWidget {
  const RegisterLoginAction({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;

    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Already have an account? ', style: t.bodySmall),
          GestureDetector(
            onTap: () => context.goNamed(RouteNames.login),
            child: Text(
              'Login',
              style: t.titleSmall?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
