import 'package:flutter/material.dart';
import 'package:scenario_management/custom_widgets/add_scenario_form/add_scenario_form_connector.dart';
import '../../constants/role_based_theme.dart';
import '../../models/user_model.dart';
import '../../models/scenario.dart';
import '../../route_names/route_names.dart';

class HomeScreen extends StatefulWidget {
  final bool isLoading;
  final UserModel userModel;
  final Scenario scenario;
  final void Function() signOut;
  final void Function() checkExistingUser;
  final void Function() getProjects;
  final void Function(Scenario scenario) addScenario;
  final void Function(Scenario scenario) updateScenarioStore;
  final void Function(String projectID) fetchScenariosByProject;
  final List<Map<String, dynamic>> projects;
  final Map<String, List<Scenario>> projectScenarios;

  const HomeScreen({
    super.key,
    required this.isLoading,
    required this.userModel,
    required this.scenario,
    required this.signOut,
    required this.checkExistingUser,
    required this.addScenario,
    required this.getProjects,
    required this.fetchScenariosByProject,
    required this.projects,
    required this.projectScenarios,
    required this.updateScenarioStore,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    widget.checkExistingUser();
    widget.getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home - ${widget.userModel.designation ?? 'User'}'),
        backgroundColor: roleColors[widget.userModel.designation ?? 'Tester'],
      ),
      body:widget.isLoading == true
          ? const Center(child: CircularProgressIndicator())
          :Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${widget.userModel.email}',
                      style: const TextStyle(fontSize: 16)),
                  Text('Designation: ${widget.userModel.designation}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  // Display projects and their scenarios using ExpansionTile
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.projects.length,
                      itemBuilder: (context, index) {
                        final project = widget.projects[index];
                        final projectId = project['id'] ??
                            'Unknown ID'; // Use 'id' instead of 'projectID'
                        final projectName =
                            project['name'] ?? 'Unnamed Project';

                        return ExpansionTile(
                          title: Text(projectName),
                          onExpansionChanged: (expanded) {
                            setState(() {
                              _expandedStates[projectId] = expanded;
                            });

                            // Fetch scenarios only if expanded and not already loaded
                            if (expanded && (widget.projectScenarios[projectId] == null || widget.projectScenarios[projectId]!.isEmpty)) {
                              widget.fetchScenariosByProject(projectId);
                            }
                          },
                          children: [
                            if (widget.projectScenarios[projectId]?.isEmpty ?? true)
                              const ListTile(
                                title: Text('No scenarios available for this project'),
                              )
                            else
                              ...widget.projectScenarios[projectId]!.map((scenario) {
                                return Card(
                                  shadowColor: Colors.lightBlue,
                                  child: ListTile(
                                    title: Text('Scenario Name: ${scenario.name}'),
                                    subtitle: Text('Scenario description: ${scenario.description}'),
                                    trailing: const Text(
                                      'Add Test Case',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onTap: () {
                                      widget.updateScenarioStore(scenario);
                                      Navigator.pushNamed(
                                          context, RoutesName.testCaseScreen,
                                          arguments: scenario);
                                    },
                                  ),
                                );
                              }).toList(),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {

                      showDialog(
                          context: context,
                          builder: (context) => const AddScenarioConnector());
                    },
                    child: const Text('Add New Scenario'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.signOut();
                      Navigator.pushNamed(context, RoutesName.loginScreen);
                    },
                    child: const Text('Log out'),
                  ),
                ],
              ),
            ),
    );
  }
}
