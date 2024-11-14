import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/custom_widgets/add_scenario_form/add_scenario_form_connector.dart';
import 'package:scenario_management/redux/actions/add_scenario_from/fetch_projects_action.dart';
import 'package:scenario_management/redux/actions/home_screen/add_scenario_action.dart';
import '../../../redux/app_state.dart';
import '../../models/scenario.dart';
import '../../models/user_model.dart';

///Login Screen View Model
class AddScenarioViewModel extends Vm {
  final UserModel userModel;
  final Scenario scenario;
  final List<Map<String, dynamic>> projects;
  final void Function() fetchProjects;
  final void Function(Scenario scenario) addScenario;

  AddScenarioViewModel({
    required this.userModel,
    required this.scenario,
    required this.projects,
    required this.fetchProjects,
    required this.addScenario
  }) : super(equals: [userModel,scenario,projects]);
}

class Factory
    extends VmFactory<AppState, AddScenarioConnector, AddScenarioViewModel> {
  Factory(connector) : super(connector);

  @override
  AddScenarioViewModel fromStore() => AddScenarioViewModel(
    userModel: state.userModel,
    scenario:  state.scenario,
    projects: state.projects,
    fetchProjects:()=>dispatch(FetchProjectsAction()),
    addScenario: (Scenario scenario)=> dispatch(AddScenarioAction(scenario: scenario)),
  );
}
