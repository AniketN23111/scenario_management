import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/constants/enums.dart';
import 'package:scenario_management/redux/actions/home_screen/add_scenario_action.dart';
import 'package:scenario_management/redux/actions/home_screen/fetch_scenario_by_project.dart';
import 'package:scenario_management/redux/actions/home_screen/get_user_role_action.dart';
import 'package:scenario_management/redux/actions/test_case/update_scenario_action.dart';

import '../../models/scenario.dart';
import '../../models/user_model.dart';
import '../../redux/actions/home_screen/check_existing_user_action.dart';
import '../../redux/actions/home_screen/home_page_signout_action.dart';
import '../../redux/app_state.dart';
import 'home_screen_connector.dart';

class HomeScreenViewModel extends Vm {
  final bool isLoading;
  final UserModel userModel;
  final Scenario scenario;
  final UserRole userRole;
  final void Function() signOut;
  final void Function() checkExistingUser;
  final void Function(Scenario scenario) addScenario;
  final void Function(Scenario scenario) updateScenarioStore;
  final void Function(String projectID) fetchScenariosByProject;
  final List<Map<String, dynamic>> projects;
  final Map<String, List<Scenario>> projectScenarios;
  final void Function(String roleID) getRole;

  HomeScreenViewModel(
      {required this.isLoading,
      required this.userModel,
      required this.scenario,
      required this.userRole,
      required this.signOut,
      required this.checkExistingUser,
      required this.addScenario,
      required this.updateScenarioStore,
      required this.fetchScenariosByProject,
      required this.projects,
      required this.projectScenarios,
      required this.getRole})
      : super(equals: [
          isLoading,
          userModel,
          projects,
          scenario,
          userRole,
          projectScenarios
        ]);
}

class Factory
    extends VmFactory<AppState, HomeScreenConnector, HomeScreenViewModel> {
  Factory(connector) : super(connector);

  @override
  HomeScreenViewModel? fromStore() => HomeScreenViewModel(
      isLoading: state.loading,
      userModel: state.userModel,
      scenario: state.scenario,
      projects: state.projects,
      userRole: state.userRole,
      projectScenarios: state.projectScenarios,
      fetchScenariosByProject: (String projectID) =>
          dispatch(FetchScenarioByProjectAction(projectID)),
      signOut: () => dispatch(MyHomePageSignOutAction()),
      checkExistingUser: () => dispatch(CheckExistingUserAction()),
      updateScenarioStore: (Scenario scenario) =>
          dispatch(UpdateScenarioAction(scenario)),
      addScenario: (Scenario scenario) =>
          dispatch(AddScenarioAction(scenario: scenario)),
      getRole: (String roleID) => dispatch(GetUserRoleAction(roleID: roleID)));
}
