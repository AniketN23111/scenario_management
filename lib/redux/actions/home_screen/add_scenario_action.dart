import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/models/scenario.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loaded.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loading.dart';

import '../../app_state.dart';

class AddScenarioAction extends ReduxAction<AppState> {
  final Scenario scenario;

  AddScenarioAction({required this.scenario});

  @override
  Future<AppState> reduce() async {
    await FirestoreService().addScenario(scenario);
    return state.copy(scenario: scenario);
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
