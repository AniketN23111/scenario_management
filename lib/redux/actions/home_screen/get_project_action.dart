import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loaded.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loading.dart';

import '../../app_state.dart';

///Check CheckExistingUser Action
class GetProjectAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    final projects = await FirestoreService().getProjects();
    return state.copy(projects: projects);
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
