class FileFormatter {
  static String formatFileSize(String? sizeBytes) {
    if (sizeBytes == null) return 'Unknown';

    try {
      final bytes = int.parse(sizeBytes);
      if (bytes < 1024) return '${bytes}B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
      if (bytes < 1024 * 1024 * 1024) {
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
      }
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    } catch (e) {
      return sizeBytes;
    }
  }

  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
