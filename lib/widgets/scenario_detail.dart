import 'package:flutter/material.dart';
import '../firebase/firestore_services.dart';
import '../models/scenario.dart';
import '../models/test_cases.dart';

class ScenarioDetail extends StatelessWidget {
  final Scenario scenario;
  final FirestoreService firestoreService = FirestoreService();

  ScenarioDetail({required this.scenario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(scenario.project),
      ),
      body: FutureBuilder<List<TestCase>>(
        future: firestoreService.getTestCasesByScenario(scenario.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final testCases = snapshot.data ?? [];
          if (testCases.isEmpty) {
            return const Center(child: Text('No test cases found for this scenario.'));
          }

          return ListView.builder(
            itemCount: testCases.length,
            itemBuilder: (context, index) {
              final testCase = testCases[index];
              return ListTile(
                title: Text(testCase.name),
                subtitle: Text('Status: ${testCase.status}'),
                trailing: Text(testCase.bugId),
              );
            },
          );
        },
      ),
    );
  }
}
