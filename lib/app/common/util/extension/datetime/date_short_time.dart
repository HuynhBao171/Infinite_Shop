import 'package:easy_localization/easy_localization.dart';

/// Extension method to get a short, relative time string for how long ago
extension ShortTimeExt on DateTime {
  /// Returns a short, relative time string for how long ago [DateTime] was.
  /// Examples:
  /// - 1 second ago => 'just now'
  /// - 59 seconds ago => '59s ago'
  /// - 1 minute ago => '1m ago'
  /// - 59 minutes ago => '59m ago'
  /// - 1 hour ago => '1h ago'
  /// - 23 hours ago => '23h ago'
  /// - 1 day ago => '1d ago'
  /// - 6 days ago => '6d ago'
  /// - 4 weeks ago => '4wk ago'
  /// - >4 weeks ago => 'MMM d' formatted date

  String get shortTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference < const Duration(seconds: 1)) {
      return 'just now';
    }

    if (difference < const Duration(minutes: 1)) {
      return '${difference.inSeconds}s ago';
    }

    if (difference < const Duration(hours: 1)) {
      return '${difference.inMinutes}m ago';
    }

    if (difference < const Duration(days: 1)) {
      return '${difference.inHours}h ago';
    }

    if (difference < const Duration(days: 7)) {
      return '${difference.inDays}d ago';
    }

    if (difference < const Duration(days: 30)) {
      return '${difference.inDays ~/ 7}wk ago';
    }

    return DateFormat('MMM d').format(this);
  }
}
