import 'package:file_pod/core/configs/router-configs/route_names.dart';
import 'package:file_pod/features/storage/presentation/screens/storage_detail_screen.dart';
import 'package:file_pod/features/storage/presentation/screens/storage_screen.dart';
import 'package:file_pod/features/storage/presentation/screens/storage_stat_screen.dart';
import 'package:file_pod/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:file_pod/features/auth/presentation/screens/login_screen.dart';
import 'package:file_pod/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: RouteNames.welcome,
    routes: [
      GoRoute(
        name: RouteNames.welcome,
        path: RouteNames.welcome,
        builder: (context, state) => WelcomeScreen(),
      ),
      GoRoute(
        name: RouteNames.login,
        path: RouteNames.login,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        name: RouteNames.register,
        path: RouteNames.register,
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        name: RouteNames.storage,
        path: RouteNames.storage,
        builder: (context, state) => StorageScreen(),
      ),
      GoRoute(
        name: RouteNames.storageDetail,
        path: RouteNames.storageDetail,
        builder: (context, state) => StorageDetailScreen(),
      ),
      GoRoute(
        name: RouteNames.storageStat,
        path: RouteNames.storageStat,
        builder: (context, state) => StorageStatScreen(),
      ),
    ],
  );
});
