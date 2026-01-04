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

  static String? getRemainingTime(DateTime? endTime, {bool short = false}) {
    if (endTime == null) return null;
    
    final now = DateTime.now();
    if (now.isAfter(endTime)) return null; // Or "Ended" if you prefer

    final difference = endTime.difference(now);
    
    if (short) {
      if (difference.inDays > 0) {
        return "${difference.inDays}d left";
      } else if (difference.inHours > 0) {
        return "${difference.inHours}h left";
      } else {
        return "${difference.inMinutes}m left";
      }
    } else {
      if (difference.inDays > 0) {
        return "${difference.inDays}d ${difference.inHours % 24}h left";
      } else if (difference.inHours > 0) {
        return "${difference.inHours}h ${difference.inMinutes % 60}m left";
      } else {
        return "${difference.inMinutes}m left";
      }
    }
  }
}
