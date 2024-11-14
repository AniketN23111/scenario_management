import '../models/scenario.dart';
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
  final Future<List<TestCase>> listTestCase;

  AppState(
      {required this.loading,
      required this.userModel,
      required this.testCase,
      required this.scenario,
      required this.projects,
      required this.projectScenarios,
      required this.listTestCase});

  AppState copy(
          {bool? loading,
          UserModel? userModel,
          TestCase? testCase,
          Scenario? scenario,
          List<Map<String, dynamic>>? projects,
          Map<String, List<Scenario>>? projectScenarios,
          Future<List<TestCase>>? listTestCase}) =>
      AppState(
          loading: loading ?? this.loading,
          userModel: userModel ?? this.userModel,
          testCase: testCase ?? this.testCase,
          scenario: scenario ?? this.scenario,
          projects: projects ?? this.projects,
          projectScenarios: projectScenarios ?? this.projectScenarios,
          listTestCase: listTestCase ?? this.listTestCase);

  static AppState initState() => AppState(
      loading: false,
      userModel: UserModel(),
      testCase: TestCase(),
      scenario: Scenario.empty(),
      projects: [],
      projectScenarios: {},
      listTestCase: Future.value([]));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          loading == other.loading &&
          userModel == other.userModel &&
          testCase == other.testCase &&
          projects == other.projects &&
          projectScenarios == other.projectScenarios &&
          listTestCase == other.listTestCase;

  @override
  int get hashCode =>
      loading.hashCode ^
      userModel.hashCode ^
      testCase.hashCode ^
      projects.hashCode ^
      projectScenarios.hashCode ^
      listTestCase.hashCode;
}
