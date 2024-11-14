import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loaded.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loading.dart';
import '../../../models/scenario.dart';
import '../../app_state.dart';

class FetchScenarioByProjectAction extends ReduxAction<AppState> {
  final String projectId;

  FetchScenarioByProjectAction(this.projectId);

  @override
  Future<AppState?> reduce() async {
    try {
      // Fetch scenarios as List<Scenario> from Firestore
      final List<Scenario> scenarios = await FirestoreService().getScenariosByProject(projectId);

      // Create a new map and add the fetched scenarios for the project ID
      final updatedProjectScenarios = Map<String, List<Scenario>>.from(state.projectScenarios);
      updatedProjectScenarios[projectId] = scenarios;

      // Return a new state with the updated project scenarios map
      return state.copy(projectScenarios: updatedProjectScenarios);
    } catch (e) {
      print('Error fetching scenarios: $e');
      return null; // Handle error if needed
    }
  }

  @override
  void before() {
    dispatch(IsLoading()); // Optional loading action
    super.before();
  }

  @override
  void after() {
    dispatch(IsLoaded()); // Optional loaded action
    super.after();
  }
}
