import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status) {
    case 'Passed':
      return Colors.green;
    case 'Failed':
      return Colors.red;
    case 'In-Review':
      return Colors.orange;
    case 'Completed':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}