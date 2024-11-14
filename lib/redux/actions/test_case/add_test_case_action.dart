import 'package:async_redux/async_redux.dart';
import '../../../firebase/firestore_services.dart';
import '../../../models/scenario.dart';
import '../../../models/test_cases.dart';
import '../../app_state.dart';
import '../loading_actions/is_loaded.dart';
import '../loading_actions/is_loading.dart';

class UpdateTestCaseAction extends ReduxAction<AppState> {
  final String testCaseId;
  final Scenario scenario;
  final TestCase updatedTestCase;

  UpdateTestCaseAction({
    required this.testCaseId,
    required this.scenario,
    required this.updatedTestCase,
  });

  @override
  Future<AppState?> reduce() async {
    final firestoreService = FirestoreService();

    // Update the test case in Firestore
    await firestoreService.addTestCase(scenario.projectID,testCaseId,updatedTestCase);

    // Update the single test case in the local state if the ID matches
    TestCase newTestCase = (state.testCase.id == testCaseId) ? updatedTestCase : state.testCase;

    // Return the new state with the updated test case
    return state.copy(testCase: newTestCase);
  }
  @override
  void before() {
    dispatch(IsLoading());
    super.before();
  }

  @override
  void after() {
    dispatch(IsLoaded());
    super.after();
  }
}
