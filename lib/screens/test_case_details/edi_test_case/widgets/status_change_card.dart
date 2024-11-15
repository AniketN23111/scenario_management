import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/status_change_log.dart';

class StatusChangeCard extends StatelessWidget {
  final StatusChange statusChange;

  const StatusChangeCard({
    required this.statusChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = getStatusColor(statusChange.status);
    IconData statusIcon = getStatusIcon(statusChange.status);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: statusColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(statusIcon, color: Colors.white),
        title: Text(
          'Status: ${statusChange.status}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Updated by: ${statusChange.updatedBy}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat.yMd()
                  .add_jm()
                  .format(statusChange.updatedAt ?? DateTime.now()),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

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

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Passed':
        return Icons.check_circle;
      case 'Failed':
        return Icons.cancel;
      case 'In-Review':
        return Icons.pending;
      case 'Completed':
        return Icons.done_all;
      default:
        return Icons.info;
    }
  }
}
