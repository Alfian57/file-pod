import 'dart:convert';

String? extractApiMessage(Object? obj) {
  try {
    if (obj == null) return null;

    try {
      final message = (obj as dynamic).message;
      if (message is String) return message;
    } catch (_) {
      // ignore
    }

    if (obj is Map) {
      final val = obj['message'];
      if (val is String) return val;
    }

    if (obj is String) {
      final s = obj.trim();
      if (s.startsWith('{') || s.startsWith('[')) {
        try {
          final decoded = jsonDecode(s);
          if (decoded is Map && decoded['message'] is String) {
            return decoded['message'] as String;
          }
        } catch (_) {
          // ignore json errors
        }
      }
      return s;
    }

    return obj.toString();
  } catch (_) {
    return null;
  }
}
