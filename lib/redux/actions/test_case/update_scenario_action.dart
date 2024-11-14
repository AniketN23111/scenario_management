import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/models/scenario.dart';
import 'package:scenario_management/redux/app_state.dart';

class UpdateScenarioAction extends ReduxAction<AppState> {
  final Scenario scenario;

  UpdateScenarioAction(this.scenario);

  @override
  AppState reduce() {
    // Update the scenario in AppState
    return state.copy(scenario: scenario);
  }
}
