import 'package:async_redux/async_redux.dart';
import '../../../firebase/firestore_services.dart';
import '../../../models/scenario.dart';
import '../../../models/test_cases.dart';
import '../../app_state.dart';
import '../loading_actions/is_loaded.dart';
import '../loading_actions/is_loading.dart';

class GetTestCaseByScenarioAction extends ReduxAction<AppState> {
  final Scenario scenario;

  GetTestCaseByScenarioAction({
    required this.scenario,
  });

  @override
  Future<AppState?> reduce() async {
    try {
      final firestoreService = FirestoreService();
      List<TestCase> list = await firestoreService.getTestCasesByScenario(
          scenario.projectID, scenario.id);
      return state.copy(listTestCase: list);
    } catch (e) {
      print("Error fetching test cases: $e");
      return null;
    }
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
