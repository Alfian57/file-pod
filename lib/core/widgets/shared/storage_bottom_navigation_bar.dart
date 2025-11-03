import 'package:file_pod/core/configs/router-configs/route_names.dart';
import 'package:flutter/material.dart';
import '../../../theme.dart';
import 'package:go_router/go_router.dart';

class StorageBottomNavigationBar extends StatelessWidget {
  const StorageBottomNavigationBar({super.key});

  int _getCurrentIndex(String location) {
    if (location.startsWith(RouteNames.storageStat)) {
      return 1;
    } else if (location.startsWith(RouteNames.storage)) {
      return 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation; 
    final currentIndex = _getCurrentIndex(location);

    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Statistics',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: currentIndex,
      selectedItemColor: AppTheme.primary,
      unselectedItemColor: AppTheme.textSecondary,
      onTap: (index) {
        if (index == 0) {
          context.goNamed(RouteNames.storage);
        } else if (index == 1) {
          context.goNamed(RouteNames.storageStat);
        } else if (index == 2) {
          context.goNamed(RouteNames.storage);
        }
      },
    );
  }
}
