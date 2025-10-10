import 'package:file_pod/core/configs/router-configs/router_names.dart';
import 'package:file_pod/features/storage/presentation/screens/storage_detail_screen.dart';
import 'package:file_pod/features/storage/presentation/screens/storage_screen.dart';
import 'package:file_pod/features/welcome/presentation/screens/welcome/welcome_screen.dart';
import 'package:file_pod/features/auth/presentation/screens/login/login_screen.dart';
import 'package:file_pod/features/auth/presentation/screens/register/register_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/storage",
    routes: [
      GoRoute(
        name: RouteNames.welcome,
        path: '/welcome',
        builder: (context, state) => WelcomeScreen(),
      ),
      GoRoute(
        name: RouteNames.login,
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        name: RouteNames.register,
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        name: RouteNames.storage,
        path: '/storage',
        builder: (context, state) => StorageScreen(),
      ),
      GoRoute(
        name: RouteNames.storageDetail,
        path: '/storage-detail',
        builder: (context, state) => StorageDetailScreen(),
      ),
    ],
  );
});
