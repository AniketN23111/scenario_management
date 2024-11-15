import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/redux/actions/edit_test_case_screen/status_change_list_action.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loaded.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loading.dart';

import '../../app_state.dart';

class StatusChangeAction extends ReduxAction<AppState> {
  String testCaseId;
  Map<String, dynamic> statusChangeData;

  StatusChangeAction(
      {required this.testCaseId, required this.statusChangeData});

  @override
  Future<AppState> reduce() async {
    FirestoreService().addStatusChange(statusChangeData);
    return state.copy();
  }

  @override
  void before() {
    dispatch(IsLoading());
    super.before();
  }

  @override
  void after() {
    dispatch(StatusChangeListAction(testCaseId: testCaseId));
    dispatch(IsLoaded());
    super.after();
  }
}
