import 'package:flutter/material.dart';
import '../../constants/enums.dart';
import '../../models/user_model.dart';
import '../../models/scenario.dart';
import '../../route_names/route_names.dart';
import '../test_case_details/add_scenario_form/add_scenario_form_connector.dart';

class HomeScreen extends StatefulWidget {
  final bool isLoading;
  final UserModel userModel;
  final Scenario scenario;
  final UserRole userRole;
  final void Function() signOut;
  final void Function() checkExistingUser;
  final void Function() getProjects;
  final void Function(Scenario scenario) addScenario;
  final void Function(Scenario scenario) updateScenarioStore;
  final void Function(String projectID) fetchScenariosByProject;
  final void Function(String roleID) getRole;
  final List<Map<String, dynamic>> projects;
  final Map<String, List<Scenario>> projectScenarios;

  const HomeScreen(
      {super.key,
      required this.isLoading,
      required this.userModel,
      required this.scenario,
      required this.userRole,
      required this.signOut,
      required this.checkExistingUser,
      required this.addScenario,
      required this.getProjects,
      required this.fetchScenariosByProject,
      required this.projects,
      required this.projectScenarios,
      required this.updateScenarioStore,
      required this.getRole});

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
        title: Text(
          'Home - ${widget.userRole.name.capitalize()}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,),
            onPressed: () {
              widget.signOut();
              Navigator.pushNamed(context, RoutesName.loginScreen);
            },
          ),
        ],
        elevation: 0,
        centerTitle: true,
      ),
      body: widget.isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 // Image.network('https://dev.orderbookings.com/public/imagetest/c35f2b16-2ab8-4eeb-8ad7-4f2532c85bfe.jpg'),
                  const SizedBox(height: 20),
                  // Display projects and their scenarios using ExpansionTile
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.projects.length,
                      itemBuilder: (context, index) {
                        final project = widget.projects[index];
                        final projectId = project['id'] ?? 'Unknown ID';
                        final projectName = project['name'] ?? 'Unnamed Project';

                        // Check if the project is expanded
                        final isExpanded = _expandedStates[projectId] ?? false;

                        return Column(
                          children: [
                            ExpansionTile(
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Colors.grey[300],
                              collapsedBackgroundColor: Colors.grey[300],
                              collapsedShape:RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(12)),
                              title: Text(
                                projectName,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              initiallyExpanded: isExpanded,
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
                                    title: Text('No scenarios available for this project'),
                                  )
                                else
                                  ...widget.projectScenarios[projectId]!.map((scenario) {
                                    return ListTile(
                                      title: Text(
                                        scenario.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      subtitle: Text(
                                        scenario.description,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      trailing: const Text(
                                        'View Test Cases',
                                        style: TextStyle(color: Colors.blue,fontSize: 14),
                                      ),
                                      onTap: () {
                                        widget.updateScenarioStore(scenario);
                                        Navigator.pushNamed(
                                          context,
                                          RoutesName.testCaseScreen,
                                          arguments: scenario,
                                        );
                                      },
                                    );
                                  }),
                              ],
                            ),
                            // Add a gap after each project
                            const SizedBox(height: 20),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
