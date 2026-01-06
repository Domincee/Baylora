import 'package:baylora_prjct/feature/home/constant/home_strings.dart';

class DateUtil {
  static String getTimeAgo(String? dateString) {
    if (dateString == null) return HomeStrings.justNow;
    
    final date = DateTime.parse(dateString).toLocal();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}${HomeStrings.suffixYearAgo}';
    }
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}${HomeStrings.suffixMonthAgo}';
    }
    if (difference.inDays > 1) {
      return '${difference.inDays}${HomeStrings.suffixDaysAgo}';
    }
    if (difference.inDays == 1) {
      return HomeStrings.yesterday;
    }
    if (difference.inHours >= 1) {
      return '${difference.inHours}${HomeStrings.suffixHoursAgo}';
    }
    if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}${HomeStrings.suffixMinutesAgo}';
    }
    
    return HomeStrings.justNow;
  }

  static String? getRemainingTime(DateTime? endTime, {bool short = false}) {
    if (endTime == null) return null;
    
    final now = DateTime.now();
    if (now.isAfter(endTime)) return null; // Or "Ended" if you prefer

    final difference = endTime.difference(now);
    
    if (short) {
      if (difference.inDays > 0) {
        return "${difference.inDays}${HomeStrings.suffixDaysLeft}";
      } else if (difference.inHours > 0) {
        return "${difference.inHours}${HomeStrings.suffixHoursLeft}";
      } else {
        return "${difference.inMinutes}${HomeStrings.suffixMinutesLeft}";
      }
    } else {
      if (difference.inDays > 0) {
        return "${difference.inDays}${HomeStrings.unitDay} ${difference.inHours % 24}${HomeStrings.unitHour}${HomeStrings.left}";
      } else if (difference.inHours > 0) {
        return "${difference.inHours}${HomeStrings.unitHour} ${difference.inMinutes % 60}${HomeStrings.unitMinute}${HomeStrings.left}";
      } else {
        return "${difference.inMinutes}${HomeStrings.unitMinute}${HomeStrings.left}";
      }
    }
  }
}
