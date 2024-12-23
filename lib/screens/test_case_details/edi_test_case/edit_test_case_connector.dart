import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:scenario_management/constants/enums.dart';
import 'package:scenario_management/models/scenario.dart';
import 'package:scenario_management/models/user_model.dart';
import 'package:scenario_management/screens/test_case_details/edi_test_case/edit_test_case_view_model.dart';

import '../../../models/comments.dart';
import '../../../models/status_change_log.dart';
import '../../../models/test_cases.dart';
import '../../../redux/app_state.dart';
import 'edit_test_case_screen.dart';

///Test Case Screen Connector
class EditTestCaseScreenConnector extends StatelessWidget {
  final TestCase? testCase;
  final UserModel? userModel;
  final Scenario? scenario;
  final UserRole? userRole;
  final List<StatusChange>? statusChangeList;
  final List<Comments>? commentList;

  const EditTestCaseScreenConnector({
    super.key,
    this.testCase,
    this.scenario,
    this.userRole,
    this.userModel,
    this.statusChangeList,
    this.commentList,
  });

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    final testCase = arguments is TestCase ? arguments : this.testCase;

    if (testCase == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("No test case provided.")),
      );
    }

    return StoreConnector<AppState, EditTestCaseScreenViewModel>(
      vm: () => Factory(this),
      builder: (context, vm) => EditTestCaseScreen(
        scenario: vm.scenario,
        userModel: vm.userModel,
        testCase: testCase,
        response: vm.response,
        userRole: vm.userRole,
        updateTestCase: vm.updateTestCase,
        addComment: vm.addComment,
        statusUpdate: vm.statusUpdate,
        statusChangeList: vm.statusChangeList,
        commentList: vm.commentList,
        getCommentList: vm.getCommentList,
        statusUpdateList: vm.statusUpdateList,
        onUploadImage: vm.onUploadImage,
      ),
    );
  }
}
