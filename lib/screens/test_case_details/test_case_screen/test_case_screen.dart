import 'package:flutter/material.dart';
import '../../../models/scenario.dart';
import '../../../models/test_cases.dart';
import '../../../models/user_model.dart';
import '../../../route_names/route_names.dart';
import '../add_test_case_dialog.dart';


class TestCaseScreen extends StatefulWidget {
  final Scenario? scenario;
  final UserModel? userModel;
  final Future<List<TestCase>> listTestCase;
  final void Function(Scenario scenario) getTestCaseByScenario;

  const TestCaseScreen(
      {super.key,
      required this.scenario,
      required this.userModel,
      required this.listTestCase,
      required this.getTestCaseByScenario});

  @override
  State<TestCaseScreen> createState() => _TestCaseScreenState();
}

class _TestCaseScreenState extends State<TestCaseScreen> {
  @override
  void initState() {
    super.initState();
    widget.getTestCaseByScenario(widget.scenario!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.scenario!.project} - ${widget.scenario!.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddTestCaseDialog();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<TestCase>>(
        future: widget.listTestCase,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final testCases = snapshot.data ?? [];
          if (testCases.isEmpty) {
            return const Center(
                child: Text('No test cases found for this scenario.'));
          }

          return ListView.builder(
            itemCount: testCases.length,
            itemBuilder: (context, index) {
              final testCase = testCases[index];
              return ListTile(
                title: Text('TestCase Name: ${testCase.name}'),
                subtitle: Text('Status: ${testCase.status}'),
                trailing: Text('Test Case ID: ${testCase.id}'),
                onTap: () => Navigator.pushNamed(
                    context, RoutesName.editTestCaseScreen,
                    arguments: testCase),
              );
            },
          );
        },
      ),
    );
  }

  // Show the dialog for adding a test case
  void _showAddTestCaseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTestCaseDialog(
          scenario: widget.scenario,
          userModel: widget.userModel,
          onTestCaseAdded: _refreshTestCases,
        );
      },
    );
  }

  // Refresh the list of test cases
  void _refreshTestCases() {
    setState(() {
      widget.getTestCaseByScenario(widget.scenario!);
    });
  }
}
