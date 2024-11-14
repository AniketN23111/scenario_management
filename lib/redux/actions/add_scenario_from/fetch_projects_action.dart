import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loaded.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loading.dart';

import '../../app_state.dart';

class FetchProjectsAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    // Fetch projects from FirestoreService
    List<Map<String, dynamic>> projects = await FirestoreService().getProjects();
    return state.copy(projects: projects);
  }

  @override
  void before() {
    // Dispatch the loading action to show loading status in the UI
    dispatch(IsLoading());
    super.before();
  }

  @override
  void after() {
    // Dispatch the loaded action to hide loading status in the UI
    dispatch(IsLoaded());
    super.after();
  }
}
