import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:scenario_management/redux/app_state.dart';
import 'package:scenario_management/screens/home_screen/home_screen.dart';

import '../../models/scenario.dart';
import '../../models/user_model.dart';
import 'home_screen_view_model.dart';

class HomeScreenConnector extends StatelessWidget {
  final bool? isLoading;
  final UserModel? userModel;
  final Scenario? scenario;
  final List<Map<String, dynamic>>? projects;
  final Map<String, List<Scenario>>? projectScenarios;

  const HomeScreenConnector(
      {super.key,
      this.isLoading,
      this.userModel,
      this.scenario,
      this.projects,
      this.projectScenarios});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeScreenViewModel>(
      vm: () => Factory(this),
      builder: (context, vm) => HomeScreen(
        isLoading: vm.isLoading,
        userModel: vm.userModel,
        projects: vm.projects,
        projectScenarios: vm.projectScenarios,
        scenario: vm.scenario,
        fetchScenariosByProject: vm.fetchScenariosByProject,
        signOut: vm.signOut,
        addScenario: vm.addScenario,
        getProjects: vm.getProjects,
        updateScenarioStore:vm.updateScenarioStore,
        checkExistingUser: vm.checkExistingUser,
      ),
    );
  }
}
