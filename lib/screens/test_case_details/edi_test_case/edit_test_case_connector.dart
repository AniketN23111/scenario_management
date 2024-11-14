import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:scenario_management/models/scenario.dart';
import 'package:scenario_management/models/user_model.dart';
import 'package:scenario_management/screens/test_case_details/edi_test_case/edit_test_case_view_model.dart';

import '../../../models/test_cases.dart';
import '../../../redux/app_state.dart';
import 'edit_test_case_screen.dart';

///Test Case Screen Connector
class EditTestCaseScreenConnector extends StatelessWidget {
  final TestCase? testCase;
  final UserModel? userModel;
  final Scenario? scenario;
  final void Function(Scenario scenario, TestCase updatedTestCase)? updateTestCase;


  const EditTestCaseScreenConnector(
      {super.key, this.testCase, this.scenario, this.userModel, this.updateTestCase});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute
        .of(context)!
        .settings
        .arguments;
    final testCase = arguments is TestCase ? arguments : this.testCase;

    if (testCase == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("No test case provided.")),
      );
    }

    return StoreConnector<AppState, EditTestCaseScreenViewModel>(
      vm: () => Factory(this),
      builder: (context, vm) =>
          EditTestCaseScreen(
            scenario: vm.scenario,
            userModel: vm.userModel,
            testCase: testCase,
            updateTestCase: vm.updateTestCase,
          ),
    );
  }
}
