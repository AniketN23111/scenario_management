import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loaded.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loading.dart';

import '../../app_state.dart';

class CreateProjectAction extends ReduxAction<AppState> {
  String projectName;

  CreateProjectAction({required this.projectName});

  @override
  Future<AppState> reduce() async {
    FirestoreService().createNewProject(projectName);
    return state.copy();
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
