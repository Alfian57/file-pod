import 'package:file_pod/core/configs/router-configs/route_names.dart';
import 'package:file_pod/core/constants/storage_keys.dart';
import 'package:file_pod/core/providers/auth_state_provider.dart';
import 'package:file_pod/core/providers/secure_storage_provider.dart';
import 'package:file_pod/core/utils/go_router_refresh_stream.dart';
import 'package:file_pod/features/storage/presentation/screens/storage_detail_screen.dart';
import 'package:file_pod/features/storage/presentation/screens/storage_screen.dart';
import 'package:file_pod/features/storage/presentation/screens/storage_stat_screen.dart';
import 'package:file_pod/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:file_pod/features/auth/presentation/screens/login_screen.dart';
import 'package:file_pod/features/auth/presentation/screens/register_screen.dart';
import 'package:file_pod/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  final storage = ref.read(secureStorageProvider);
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RouteNames.welcome,
    refreshListenable: GoRouterRefreshStream(authState),
    redirect: (context, state) async {
      // Check if user is authenticated
      final accessToken = await storage.read(key: StorageKeys.accessToken);
      final isAuthenticated = accessToken != null && accessToken.isNotEmpty;

      final isOnWelcome = state.matchedLocation == RouteNames.welcome;
      final isOnLogin = state.matchedLocation == RouteNames.login;
      final isOnRegister = state.matchedLocation == RouteNames.register;
      final isOnForgotPassword =
          state.matchedLocation == RouteNames.forgotPassword;

      // If authenticated and trying to access auth pages, redirect to storage
      if (isAuthenticated &&
          (isOnWelcome || isOnLogin || isOnRegister || isOnForgotPassword)) {
        return RouteNames.storage;
      }

      // If not authenticated and trying to access protected pages
      if (!isAuthenticated &&
          !isOnWelcome &&
          !isOnLogin &&
          !isOnRegister &&
          !isOnForgotPassword) {
        return RouteNames.login;
      }

      // No redirect needed
      return null;
    },
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
        name: RouteNames.forgotPassword,
        path: RouteNames.forgotPassword,
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        name: RouteNames.storage,
        path: RouteNames.storage,
        builder: (context, state) => StorageScreen(),
      ),
      GoRoute(
        name: RouteNames.storageDetail,
        path: '${RouteNames.storageDetail}/:folderId/:folderName',
        builder: (context, state) {
          final folderId = state.pathParameters['folderId'] ?? '';
          final folderName = state.pathParameters['folderName'] ?? 'Folder';
          return StorageDetailScreen(
            folderId: folderId,
            folderName: folderName,
          );
        },
      ),
      GoRoute(
        name: RouteNames.storageStat,
        path: RouteNames.storageStat,
        builder: (context, state) => StorageStatScreen(),
      ),
    ],
  );
});
