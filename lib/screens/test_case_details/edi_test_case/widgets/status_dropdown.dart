import 'package:flutter/material.dart';

import '../../../../constants/enums.dart';

class StatusDropdown extends StatelessWidget {
  final String? status;
  final UserRole userRole;
  final ValueChanged<String?> onStatusChanged;

  const StatusDropdown({
    required this.status,
    required this.userRole,
    required this.onStatusChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the list of statuses
    final statuses = ['Passed', 'Failed', 'In-Review', 'Completed'];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: DropdownButtonFormField<String>(
          value: status != null && statuses.contains(status) ? status : null,
          decoration: const InputDecoration(
              labelText: 'Status', enabledBorder: (InputBorder.none)),
          items: statuses.map((status) {
            // Disable "Completed" for Junior Tester
            bool isEnabled =
                !(userRole == UserRole.juniorTester && status == 'Completed');
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
            // Prevent changing to "Completed" for Junior Tester
            if (!(userRole == UserRole.juniorTester && value == 'Completed')) {
              onStatusChanged(value);
            }
          },
          hint: Text(status ?? 'Select Status'),
        ),
      ),
    );
  }
}
