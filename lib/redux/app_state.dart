import 'package:scenario_management/models/comments.dart';

import '../constants/enums.dart';
import '../constants/response.dart';
import '../models/scenario.dart';
import '../models/status_change_log.dart';
import '../models/test_cases.dart';
import '../models/user_model.dart';

///Global Store
class AppState {
  final bool loading;
  final UserModel userModel;
  final TestCase testCase;
  final Scenario scenario;
  final List<Map<String, dynamic>> projects;
  final Map<String, List<Scenario>> projectScenarios;
  final List<TestCase> listTestCase;
  final List<StatusChange> statusChangeList;
  final List<Comments> commentList;
  final UserRole userRole;
  final Response response;
  final String err;

  AppState(
      {required this.loading,
      required this.userModel,
      required this.testCase,
      required this.scenario,
      required this.projects,
      required this.projectScenarios,
      required this.listTestCase,
      required this.statusChangeList,
      required this.commentList,
      required this.userRole,
      required this.response,
      required this.err});

  AppState copy(
          {bool? loading,
          UserModel? userModel,
          TestCase? testCase,
          Scenario? scenario,
          List<Map<String, dynamic>>? projects,
          Map<String, List<Scenario>>? projectScenarios,
          List<TestCase>? listTestCase,
          List<StatusChange>? statusChangeList,
          List<Comments>? commentList,
          UserRole? userRole,
          Response? response,
          String? err}) =>
      AppState(
          loading: loading ?? this.loading,
          userModel: userModel ?? this.userModel,
          testCase: testCase ?? this.testCase,
          scenario: scenario ?? this.scenario,
          projects: projects ?? this.projects,
          projectScenarios: projectScenarios ?? this.projectScenarios,
          listTestCase: listTestCase ?? this.listTestCase,
          statusChangeList: statusChangeList ?? this.statusChangeList,
          commentList: commentList ?? this.commentList,
          userRole: userRole ?? this.userRole,
          response: response ?? this.response,
          err: err ?? this.err);

  static AppState initState() => AppState(
      loading: false,
      userModel: UserModel(),
      testCase: TestCase(),
      scenario: Scenario.empty(),
      projects: [],
      projectScenarios: {},
      listTestCase: [],
      statusChangeList: [],
      commentList: [],
      userRole: UserRole.juniorTester,
      response: Response(),
      err: '');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          loading == other.loading &&
          userModel == other.userModel &&
          testCase == other.testCase &&
          projects == other.projects &&
          projectScenarios == other.projectScenarios &&
          listTestCase == other.listTestCase &&
          statusChangeList == other.statusChangeList &&
          commentList == other.commentList &&
          response == other.response &&
          err == other.err;

  @override
  int get hashCode =>
      loading.hashCode ^
      userModel.hashCode ^
      testCase.hashCode ^
      projects.hashCode ^
      projectScenarios.hashCode ^
      listTestCase.hashCode ^
      statusChangeList.hashCode ^
      commentList.hashCode ^
      response.hashCode ^
      err.hashCode;
}
