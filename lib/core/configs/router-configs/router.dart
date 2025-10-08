import 'package:file_pod/core/configs/router-configs/router_names.dart';
import 'package:file_pod/features/welcome/presentation/screens/welcome/welcome_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = FutureProvider((ref) async {
  return GoRouter(
    initialLocation: "/welcome",
    routes: [
      GoRoute(
        name: RouteNames.welcome,
        path: '/welcome',
        builder: (context, state) => WelcomeScreen(),
      ),
    ],
  );
});
