import 'package:flutter/material.dart';

IconData getStatusIcon(String status) {
  switch (status) {
    case 'Passed':
      return Icons.check_circle;
    case 'Failed':
      return Icons.cancel;
    case 'In-Review':
      return Icons.schedule;
    case 'Completed':
      return Icons.done_all;
    default:
      return Icons.help;
  }
}