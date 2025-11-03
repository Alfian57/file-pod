import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(AsyncValue<bool> authState) {
    authState.whenData((value) {
      notifyListeners();
    });
  }
}
