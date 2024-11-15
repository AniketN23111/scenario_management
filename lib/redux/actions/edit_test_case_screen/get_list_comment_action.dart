import 'dart:async';
import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loaded.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loading.dart';

import '../../../models/comments.dart';
import '../../app_state.dart';

class GetCommentListAction extends ReduxAction<AppState> {
  final String testCaseId;

  GetCommentListAction({required this.testCaseId});

  @override
  Future<AppState> reduce() async {
    final List<Comments> list = await FirestoreService().fetchComments(testCaseId);
    log("this is the action to fetch the comments ${list}");
    return state.copy(commentList: list);
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
