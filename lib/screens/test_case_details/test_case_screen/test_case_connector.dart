import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:scenario_management/models/scenario.dart';
import 'package:scenario_management/models/user_model.dart';
import 'package:scenario_management/screens/test_case_details/test_case_screen/test_case_screen.dart';
import 'package:scenario_management/screens/test_case_details/test_case_screen/test_case_screen_view_model.dart';

import '../../../models/test_cases.dart';
import '../../../redux/app_state.dart';

///Test Case Screen Connector
class TestCaseScreenConnector extends StatelessWidget {
  final Scenario? scenario;
  final UserModel? userModel;
  final Future<List<TestCase>>? listTestCase;

  const TestCaseScreenConnector({super.key, this.scenario, this.userModel,this.listTestCase});

  @override
  Widget build(BuildContext context) {
    final Scenario scenario = ModalRoute.of(context)!.settings.arguments as Scenario;
    return StoreConnector<AppState, TestCaseScreenViewModel>(
      vm: () => Factory(this),
      builder: (context, vm) => TestCaseScreen(
        scenario: scenario,
        userModel: vm.userModel,
        listTestCase: vm.listTestCase,
        getTestCaseByScenario: vm.getTestCaseByScenario,
      ),
    );
  }
}
