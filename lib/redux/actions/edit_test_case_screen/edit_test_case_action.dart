import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/models/scenario.dart';
import 'package:scenario_management/models/test_cases.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loaded.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loading.dart';
import 'package:scenario_management/redux/actions/test_case/get_test_case_by_scenario_action.dart';

import '../../../firebase/firestore_services.dart';
import '../../app_state.dart';

class EditTestCaseAction extends ReduxAction<AppState> {
  final String testCaseId;
  final Scenario scenario;
  final TestCase updatedTestCase;

  EditTestCaseAction({
    required this.testCaseId,
    required this.scenario,
    required this.updatedTestCase,
  });

  @override
  Future<AppState?> reduce() async {
    final FirestoreService firestoreService = FirestoreService();
    await firestoreService.updateTestCase(
        testCaseId, scenario, updatedTestCase);
    return state.copy(testCase: updatedTestCase);
  }

  @override
  void before(){
    dispatch(IsLoading());
    super.before();
  }

  @override
  void after() {
    dispatch(GetTestCaseByScenarioAction(scenario: scenario));
    dispatch(IsLoaded());
    super.after();
  }
}
