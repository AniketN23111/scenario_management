import 'package:flutter/material.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/models/scenario.dart';
import 'package:scenario_management/models/user_model.dart';
import 'package:scenario_management/route_names/route_names.dart';
import 'package:scenario_management/screens/test_case_details/test_case_arguments.dart';

class ScenarioList extends StatefulWidget {
  final UserModel userModel;

  const ScenarioList({super.key, required this.userModel});

  @override
  State<ScenarioList> createState() => _ScenarioListState();
}

class _ScenarioListState extends State<ScenarioList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Scenario>>(
      future: FirestoreService().getProjectsByUser(widget.userModel.email!),
      // Fetch projects associated with the email
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final listScenarios = snapshot.data ?? [];

        if (listScenarios.isEmpty) {
          return const Center(child: Text('No projects assigned.'));
        }

        // Group scenarios by project name
        Map<String, List<Scenario>> groupedScenarios = {};
        for (var scenario in listScenarios) {
          if (groupedScenarios.containsKey(scenario.project)) {
            groupedScenarios[scenario.project]?.add(scenario);
          } else {
            groupedScenarios[scenario.project] = [scenario];
          }
        }

        return Expanded(
          child: ListView(
            children: groupedScenarios.entries.map((entry) {
              String projectName = entry.key;
              List<Scenario> projectScenarios = entry.value;

              return ExpansionTile(
                textColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                title: Text('Project Name -$projectName'),
                children: projectScenarios.map((scenario) {
                  return Card(
                    shadowColor: Colors.cyan,
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
                                userModel: widget.userModel));
                      },
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
