import 'package:flutter/material.dart';
import '../../role_based_ui/role_based_ui.dart';
import '../../firebase/firestore_services.dart';
import '../../constants/role_based_theme.dart';
import '../../models/user_model.dart';
import '../../models/scenario.dart';
import '../../route_names/route_names.dart';
import '../../constants/test_case_arguments.dart';

class HomeScreen extends StatefulWidget {
  final bool? isLoading;
  final UserModel? userModel;
  final void Function() signOut;
  final void Function() checkExistingUser;

  const HomeScreen({
    super.key,
    required this.isLoading,
    required this.userModel,
    required this.signOut,
    required this.checkExistingUser,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _projects = [];
  final Map<String, List<Scenario>> _projectScenarios = {};
  final Map<String, bool> _expandedStates = {}; // To track expanded state of projects

  @override
  void initState() {
    super.initState();
    widget.checkExistingUser();
    _fetchProjects();
  }

  // Fetch all projects from Firestore
  Future<void> _fetchProjects() async {
    final projects = await _firestoreService.getProjects();
    setState(() {
      _projects = projects;
      print('Projects fetched: $_projects'); // Debugging output
    });
  }

  /// Fetch scenarios associated with the selected project
  Future<void> _fetchScenariosByProject(String projectId) async {
    try {
      final scenarios = await _firestoreService.getScenariosByProject(projectId);
      setState(() {
        _projectScenarios[projectId] = scenarios;
      });
    } catch (e) {
      print('Error fetching scenarios: $e');
    }
  }

  /// Add scenario to Firestore
  void _addScenario(Scenario scenario) async {
    await _firestoreService.addScenario(scenario);
    _fetchScenariosByProject(scenario.projectID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home - ${widget.userModel?.designation ?? 'User'}'),
        backgroundColor: roleColors[widget.userModel?.designation ?? 'Tester'],
      ),
      body: widget.isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : widget.userModel == null
          ? const Center(child: Text('No Data Found'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${widget.userModel!.email}',
                style: const TextStyle(fontSize: 16)),
            Text('Designation: ${widget.userModel!.designation}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            // Display projects and their scenarios using ExpansionTile
            Expanded(
              child: ListView.builder(
                itemCount: _projects.length,
                itemBuilder: (context, index) {
                  final project = _projects[index];
                  final projectId = project['id'] ?? 'Unknown ID';  // Use 'id' instead of 'projectID'
                  final projectName = project['name'] ?? 'Unnamed Project';

                  return ExpansionTile(
                    title: Text(projectName),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _expandedStates[projectId] = expanded;
                      });

                      if (expanded && _projectScenarios[projectId] == null) {
                        _fetchScenariosByProject(projectId);
                      }
                    },
                    children: [
                      if (_projectScenarios[projectId]?.isEmpty ?? true)
                        const ListTile(
                          title: Text('No scenarios available for this project'),
                        )
                      else
                        ..._projectScenarios[projectId]!.map((scenario) {
                          return Card(
                            shadowColor: Colors.lightBlue,
                            child: ListTile(
                              title: Text('Scenario Name :-${scenario.name}'),
                              subtitle: Text(
                                  'Scenario description :-${scenario.description}'),
                              trailing: const Text(
                                'Add Test Case',
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, RoutesName.testCaseScreen,
                                    arguments: TestCaseScreenArguments(
                                        scenario: scenario,
                                        userModel: widget.userModel!));
                              },
                            ),
                          );
                        }),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: RoleBasedUI(
                userModel: widget.userModel,
                onAddScenario: _addScenario,
              ),
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
