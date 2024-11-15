import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/models/status_change_log.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loaded.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loading.dart';

import '../../app_state.dart';

class StatusChangeListAction extends ReduxAction<AppState> {
  String testCaseId;

  StatusChangeListAction({required this.testCaseId});

  @override
  Future<AppState> reduce() async {
    List<StatusChange> statusChangeData =
        await FirestoreService().fetchStatusChangeHistory(testCaseId);
    return state.copy(statusChangeList: statusChangeData);
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
