import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/redux/actions/add_scenario_from/create_project_action.dart';
import 'package:scenario_management/redux/actions/add_scenario_from/fetch_projects_action.dart';
import 'package:scenario_management/redux/actions/home_screen/add_scenario_action.dart';
import '../../../models/scenario.dart';
import '../../../models/user_model.dart';
import '../../../redux/app_state.dart';
import 'add_scenario_form_connector.dart';


///Login Screen View Model
class AddScenarioViewModel extends Vm {
  final UserModel userModel;
  final Scenario scenario;
  final List<Map<String, dynamic>> projects;
  final void Function() fetchProjects;
  final void Function(Scenario scenario) addScenario;
  final void Function(String projectName) createProject;

  AddScenarioViewModel({
    required this.userModel,
    required this.scenario,
    required this.projects,
    required this.fetchProjects,
    required this.addScenario,
    required this.createProject,
  }) : super(equals: [userModel, scenario, projects]);
}

class Factory
    extends VmFactory<AppState, AddScenarioConnector, AddScenarioViewModel> {
  Factory(connector) : super(connector);

  @override
  AddScenarioViewModel fromStore() => AddScenarioViewModel(
        userModel: state.userModel,
        scenario: state.scenario,
        projects: state.projects,
        fetchProjects: () => dispatch(FetchProjectsAction()),
        createProject: (String projectName) =>
            dispatch(CreateProjectAction(projectName: projectName)),
        addScenario: (Scenario scenario) =>
            dispatch(AddScenarioAction(scenario: scenario)),
      );
}
