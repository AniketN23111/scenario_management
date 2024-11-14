import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/redux/actions/test_case/get_test_case_by_scenario_action.dart';
import 'package:scenario_management/screens/test_case_details/test_case_screen/test_case_connector.dart';

import '../../../models/scenario.dart';
import '../../../models/test_cases.dart';
import '../../../models/user_model.dart';
import '../../../redux/app_state.dart';


///Test Case Screen View Model
class TestCaseScreenViewModel extends Vm {
  final Scenario scenario;
  final UserModel userModel;
  final Future<List<TestCase>> listTestCase;
  final void Function(Scenario scenario) getTestCaseByScenario;

  TestCaseScreenViewModel({
    required this.scenario,
    required this.userModel,
    required this.listTestCase,
    required this.getTestCaseByScenario
  }) : super(equals: [scenario,userModel,listTestCase]);
}

///Login Screen Factory Method
class Factory
    extends VmFactory<AppState, TestCaseScreenConnector, TestCaseScreenViewModel> {
  Factory(connector) : super(connector);

  @override
  TestCaseScreenViewModel fromStore() => TestCaseScreenViewModel(
   scenario: state.scenario,
    userModel: state.userModel,
    listTestCase: state.listTestCase,
    getTestCaseByScenario:(Scenario scenario)=> dispatch(GetTestCaseByScenarioAction(scenario: scenario)),
  );
}
