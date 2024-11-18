import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../helper/get_status_icon.dart';
import '../../../../helper/status_color.dart';
import '../../../../models/status_change_log.dart';

class StatusChangeCard extends StatelessWidget {
  final StatusChange statusChange;

  const StatusChangeCard({
    required this.statusChange,
    super.key,
  });

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
}
