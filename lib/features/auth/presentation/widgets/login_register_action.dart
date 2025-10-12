import 'package:flutter/material.dart';
import 'package:file_pod/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:file_pod/core/configs/router-configs/route_names.dart';

class LoginRegisterAction extends StatelessWidget {
  const LoginRegisterAction({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;

    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text("Don't have an account? ", style: t.bodySmall),
          GestureDetector(
            onTap: () => context.pushNamed(RouteNames.register),
            child: Text(
              'Register',
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
