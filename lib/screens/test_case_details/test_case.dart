import 'package:flutter/material.dart';
import 'add_test_case_dialog.dart';
import 'edit_test_case_screen.dart';
import '../../firebase/firestore_services.dart';
import '../../models/scenario.dart';
import '../../models/test_cases.dart';
import '../../models/user_model.dart';

class TestCaseScreen extends StatefulWidget {
  final Scenario? scenario;
  final UserModel? userModel;

  const TestCaseScreen({super.key, this.scenario, this.userModel});

  @override
  State<TestCaseScreen> createState() => _TestCaseScreenState();
}

class _TestCaseScreenState extends State<TestCaseScreen> {
  final FirestoreService firestoreService = FirestoreService();
  Future<List<TestCase>>? _testCasesFuture;

  @override
  void initState() {
    super.initState();
    _testCasesFuture = firestoreService.getTestCasesByScenario(widget.scenario!.projectID, widget.scenario!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.scenario!.project} - ${widget.scenario!.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddTestCaseDialog();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<TestCase>>(
        future: _testCasesFuture,
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
                title: Text('TestCase Name: ${testCase.name}'),
                subtitle: Text('Status: ${testCase.status}'),
                trailing: Text('Test Case ID: ${testCase.id}'),
                onTap: () => _editTestCase(testCase,widget.scenario!,widget.userModel),
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
      _testCasesFuture = firestoreService.getTestCasesByScenario(widget.scenario!.projectID, widget.scenario!.id);
    });
  }

  // Navigate to the EditTestCaseScreen for editing a test case
  void _editTestCase(TestCase testCase,Scenario scenario,UserModel? userModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTestCaseScreen(testCase: testCase,scenario :scenario,userModel: userModel!),
      ),
    );
  }
}
