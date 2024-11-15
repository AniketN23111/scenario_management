import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/models/test_cases.dart';
import 'package:scenario_management/redux/actions/edit_test_case_screen/add_comment_action.dart';
import 'package:scenario_management/redux/actions/edit_test_case_screen/edit_test_case_action.dart';
import 'package:scenario_management/redux/actions/edit_test_case_screen/get_list_comment_action.dart';
import 'package:scenario_management/redux/actions/edit_test_case_screen/status_change_action.dart';
import 'package:scenario_management/redux/actions/edit_test_case_screen/status_change_list_action.dart';
import 'package:scenario_management/screens/test_case_details/edi_test_case/edit_test_case_connector.dart';
import '../../../models/comments.dart';
import '../../../models/scenario.dart';
import '../../../models/status_change_log.dart';
import '../../../models/user_model.dart';
import '../../../redux/app_state.dart';

///Edit Test Case Screen View Model
class EditTestCaseScreenViewModel extends Vm {
  final TestCase testCase;
  final Scenario scenario;
  final UserModel userModel;
  final List<StatusChange> statusChangeList;
  final List<Comments> commentList;

  final void Function(Scenario scenario, TestCase updatedTestCase)
      updateTestCase;
  final void Function(String testCaseId, Map<String, dynamic> commentData)
      addComment;
  final void Function(String testCaseId, Map<String, dynamic> statusChangeData)
      statusUpdate;
  final void Function(String testCaseId) getCommentList;
  final void Function(String testCaseId) statusUpdateList;


  EditTestCaseScreenViewModel({
    required this.scenario,
    required this.userModel,
    required this.testCase,
    required this.commentList,
    required this.statusChangeList,
    required this.updateTestCase,
    required this.addComment,
    required this.statusUpdate,
    required this.getCommentList,
    required this.statusUpdateList
  }) : super(equals: [
          scenario,
          userModel,
          testCase,
          commentList,
          statusChangeList
        ]);
}

class Factory extends VmFactory<AppState, EditTestCaseScreenConnector,
    EditTestCaseScreenViewModel> {
  Factory(connector) : super(connector);

  @override
  EditTestCaseScreenViewModel fromStore() => EditTestCaseScreenViewModel(
      scenario: state.scenario,
      userModel: state.userModel,
      testCase: state.testCase,
      commentList: state.commentList,
      statusChangeList: state.statusChangeList,
      statusUpdateList: (String testCaseId)=>dispatch(StatusChangeListAction(testCaseId: testCaseId)),
      getCommentList: (String testCaseId)=>dispatch(GetCommentListAction(testCaseId: testCaseId)),
      addComment: (String testCaseId, Map<String, dynamic> commentData) =>
          dispatch(AddCommentAction(
              testCaseId: testCaseId, commentData: commentData)),
      statusUpdate:
          (String testCaseId, Map<String, dynamic> statusChangeData) =>
              dispatch(StatusChangeAction(
                  testCaseId: testCaseId, statusChangeData: statusChangeData)),
      updateTestCase: (Scenario scenario, TestCase updatedTestCase) => dispatch(
          EditTestCaseAction(
              testCaseId: updatedTestCase.id!,
              scenario: scenario,
              updatedTestCase: updatedTestCase)));
}
