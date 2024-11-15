import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/redux/actions/edit_test_case_screen/get_list_comment_action.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loading.dart';

import '../../app_state.dart';

class AddCommentAction extends ReduxAction<AppState> {
  String testCaseId;
  Map<String, dynamic> commentData;

  AddCommentAction({required this.testCaseId, required this.commentData});

  @override
  Future<AppState> reduce() async {
    FirestoreService().addComment(testCaseId, commentData);
    return state.copy();
  }

  @override
  void before() {
    dispatch(IsLoading());
    super.before();
  }

  @override
  void after() {
    dispatch(GetCommentListAction(testCaseId: testCaseId));
    super.after();
  }
}
