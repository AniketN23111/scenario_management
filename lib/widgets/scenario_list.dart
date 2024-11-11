import 'package:flutter/material.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/models/scenario.dart';

class ScenarioList extends StatelessWidget {
  final String email;

  const ScenarioList({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Scenario>>(
      future: FirestoreService().getProjectsByUser(email), // Fetch projects associated with the email
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final scenarios = snapshot.data ?? [];

        if (scenarios.isEmpty) {
          return const Center(child: Text('No projects assigned.'));
        }

       /// Group scenarios by project name
        Map<String, List<Scenario>> groupedScenarios = {};
        for (var scenario in scenarios) {
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
                title: Text(projectName),
                children: projectScenarios.map((scenario) {
                  return ListTile(
                    title: Text(scenario.name),
                    subtitle: Text(scenario.description),
                    onTap: () {
                      // Navigate to Scenario Details screen (you can customize this)
                    },
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
