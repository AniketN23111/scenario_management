import 'package:flutter/material.dart';
import 'package:scenario_management/screens/test_case_details/edi_test_case/widgets/status_change_card.dart';

import '../../../../models/status_change_log.dart';


class StatusChangesSection extends StatelessWidget {
  final List<StatusChange> statusChangeList;

  const StatusChangesSection({
    required this.statusChangeList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: statusChangeList.length,
        itemBuilder: (context, index) {
          final statusChange = statusChangeList[index];
          return StatusChangeCard(statusChange: statusChange);
        },
      ),
    );
  }
}
