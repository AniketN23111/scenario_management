import 'package:flutter/material.dart';

class StatusDropdown extends StatelessWidget {
  final String? status;
  final String userDesignation;
  final ValueChanged<String?> onStatusChanged;

  const StatusDropdown({
    required this.status,
    required this.userDesignation,
    required this.onStatusChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: status != null &&
          ['Passed', 'Failed', 'In-Review', 'Completed'].contains(status)
          ? status
          : null,
      decoration: const InputDecoration(labelText: 'Status'),
      items: ['Passed', 'Failed', 'In-Review', 'Completed'].map((status) {
        bool isEnabled =
            userDesignation != 'Junior Tester' || status != 'Completed';
        return DropdownMenuItem(
          value: status,
          enabled: isEnabled,
          child: Text(
            status,
            style: TextStyle(color: isEnabled ? Colors.black : Colors.grey),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (userDesignation != 'Junior Tester' || value != 'Completed') {
          onStatusChanged(value);
        }
      },
      hint: Text(status ?? 'Select Status'),
    );
  }
}
