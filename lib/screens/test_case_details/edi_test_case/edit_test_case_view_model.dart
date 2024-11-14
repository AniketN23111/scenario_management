import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/models/test_cases.dart';
import 'package:scenario_management/redux/actions/edit_test_case_screen/edit_test_case_action.dart';
import 'package:scenario_management/screens/test_case_details/edi_test_case/edit_test_case_connector.dart';
import '../../../models/scenario.dart';
import '../../../models/user_model.dart';
import '../../../redux/app_state.dart';

///Edit Test Case Screen View Model
class EditTestCaseScreenViewModel extends Vm {
  final TestCase testCase;
  final Scenario scenario;
  final UserModel userModel;

  final void Function(Scenario scenario, TestCase updatedTestCase)
      updateTestCase;

  EditTestCaseScreenViewModel({
    required this.scenario,
    required this.userModel,
    required this.testCase,
    required this.updateTestCase,
  }) : super(equals: [scenario, userModel, testCase]);
}

class Factory extends VmFactory<AppState, EditTestCaseScreenConnector,
    EditTestCaseScreenViewModel> {
  Factory(connector) : super(connector);

  @override
  EditTestCaseScreenViewModel fromStore() => EditTestCaseScreenViewModel(
      scenario: state.scenario,
      userModel: state.userModel,
      testCase: state.testCase,
      updateTestCase: (Scenario scenario, TestCase updatedTestCase) => dispatch(
          EditTestCaseAction(
              testCaseId: updatedTestCase.id!,
              scenario: scenario,
              updatedTestCase: updatedTestCase)));
}
