class DateUtil {
  static String getTimeAgo(String? dateString) {
    if (dateString == null) return 'Just now';
    
    final date = DateTime.parse(dateString).toLocal();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    }
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    }
    if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    }
    if (difference.inDays == 1) {
      return 'Yesterday';
    }
    if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    }
    if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    }
    
    return 'Just now';
  }
}
