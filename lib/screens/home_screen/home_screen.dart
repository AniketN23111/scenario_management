import 'package:flutter/material.dart';
import '../../constants/role_based_theme.dart';
import '../../models/user_model.dart';
import '../../models/scenario.dart';
import '../../route_names/route_names.dart';
import '../test_case_details/add_scenario_form/add_scenario_form_connector.dart';

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
  // Map to track the expanded state of each project
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              widget.signOut();
              Navigator.pushNamed(context, RoutesName.loginScreen);
            },
          ),
        ],
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: ${widget.userModel.email}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Designation: ${widget.userModel.designation}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            // Display projects and their scenarios using ExpansionTile
            Expanded(
              child: ListView.builder(
                itemCount: widget.projects.length,
                itemBuilder: (context, index) {
                  final project = widget.projects[index];
                  final projectId = project['id'] ?? 'Unknown ID';
                  final projectName = project['name'] ?? 'Unnamed Project';

                  return ExpansionTile(
                    title: Text(
                      projectName,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    initiallyExpanded: _expandedStates[projectId] ?? false,
                    // Maintain expanded state
                    onExpansionChanged: (expanded) async {
                      setState(() {
                        _expandedStates[projectId] = expanded;
                      });

                      // Fetch scenarios only if expanded and not already loaded
                      if (expanded &&
                          (widget.projectScenarios[projectId] == null ||
                              widget.projectScenarios[projectId]!.isEmpty)) {
                        widget.fetchScenariosByProject(projectId);
                      }
                    },
                    children: [
                      if (widget.projectScenarios[projectId]?.isEmpty ?? true)
                        const ListTile(
                          title:
                              Text('No scenarios available for this project'),
                        )
                      else
                        ...widget.projectScenarios[projectId]!.map((scenario) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadowColor: Colors.blueGrey.withOpacity(0.2),
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                'Scenario Name: ${scenario.name}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Scenario description: ${scenario.description}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
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
                        }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddScenarioConnector(),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
