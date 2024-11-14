import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:scenario_management/custom_widgets/add_scenario_form/add_scenario_form.dart';
import 'package:scenario_management/custom_widgets/add_scenario_form/add_scenario_form_view_model.dart';
import 'package:scenario_management/models/scenario.dart';
import 'package:scenario_management/models/user_model.dart';
import 'package:scenario_management/redux/app_state.dart';

class AddScenarioConnector extends StatelessWidget {
  final UserModel? userModel;
  final Scenario? scenario;
  final List<Map<String, dynamic>>? projects;

  const AddScenarioConnector(
      {super.key, this.userModel, this.scenario, this.projects});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AddScenarioViewModel>(
      vm: () => Factory(this),
      builder: (context, vm) => AddScenarioForm(
        userModel: vm.userModel,
        scenario: vm.scenario,
        projects: vm.projects,
        addScenario: vm.addScenario,
        fetchProjects: vm.fetchProjects,
      ),
    );
  }
}
