import 'package:flutter/material.dart';
import 'package:scenario_management/models/scenario.dart';
import '../../../firebase/firestore_services.dart';
import '../../../models/test_cases.dart';
import '../../../models/user_model.dart';

class EditTestCaseScreen extends StatefulWidget {
  final TestCase testCase;
  final UserModel userModel;
  final Scenario scenario;
  final void Function(Scenario scenario,TestCase updatedTestCase) updateTestCase;

  const EditTestCaseScreen({super.key, required this.testCase,required this.scenario, required this.userModel,required this.updateTestCase});

  @override
  _EditTestCaseScreenState createState() => _EditTestCaseScreenState();
}

class _EditTestCaseScreenState extends State<EditTestCaseScreen> {
  final FirestoreService firestoreService = FirestoreService();

  // Text controllers to edit test case fields
  late TextEditingController _nameController;
  late TextEditingController _bugIdController;
  late TextEditingController _descriptionController;
  late TextEditingController _commentsController;
  String? _status;
  String? _assignedUserName;
  //Future<List<String>>? _usersFuture;
  String? _userDesignation;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with current test case data
    _nameController = TextEditingController(text: widget.testCase.name);
    _bugIdController = TextEditingController(text: widget.testCase.bugId);
    _descriptionController = TextEditingController(text: widget.testCase.description);
    _commentsController = TextEditingController(text: widget.testCase.comments);
    _status = widget.testCase.status;
    _assignedUserName = widget.testCase.assignedUsers;
    //_usersFuture = firestoreService.getUserNames();
    _userDesignation = widget.userModel.designation;
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _bugIdController.dispose();
    _descriptionController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _submitTestCaseForm() async {
    // Check if the form is valid before submitting
    if (_nameController.text.isNotEmpty &&
        _bugIdController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _commentsController.text.isNotEmpty &&
        _status != null) {

      // Create the updated test case object
      TestCase updatedTestCase = TestCase(
        id: widget.testCase.id, // Keep the same ID
        name: _nameController.text,
        bugId: _bugIdController.text,
        status: _status!,
        description: _descriptionController.text,
        comments: _commentsController.text,
        attachment: widget.testCase.attachment,
        scenarioId: widget.testCase.scenarioId,
        assignedBy: widget.testCase.assignedBy,
        assignedUsers: _assignedUserName ?? widget.testCase.assignedUsers,
      );
      widget.updateTestCase(widget.scenario,updatedTestCase);

      // Show a success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test Case Updated Successfully')),
      );
      Navigator.pop(context);
    } else {
      // Show a validation error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Test Case: ${widget.testCase.name}')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Editing ${widget.testCase.name}', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),

              // Test Case Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Test Case Name'),
              ),
              const SizedBox(height: 8),

              // Bug ID
              TextFormField(
                controller: _bugIdController,
                decoration: const InputDecoration(labelText: 'Bug ID'),
              ),
              const SizedBox(height: 8),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
              ),
              const SizedBox(height: 8),

              // Comments
              TextFormField(
                controller: _commentsController,
                decoration: const InputDecoration(labelText: 'Comments'),
                maxLines: 3,
              ),
              const SizedBox(height: 8),

              // Status (Dropdown)
              DropdownButtonFormField<String>(
                value: _status != null &&
                    ['Passed', 'Failed', 'In-Review', 'Completed'].contains(_status)
                    ? _status
                    : null,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Passed', 'Failed', 'In-Review', 'Completed'].map(
                      (status) {
                    bool isEnabled = _userDesignation != 'Junior Tester' || status != 'Completed';
                    return DropdownMenuItem(
                      value: status,
                      enabled: isEnabled,
                      child: Text(status, style: TextStyle(color: isEnabled ? Colors.black : Colors.grey)),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  if (_userDesignation != 'Junior Tester' || value != 'Completed') {
                    setState(() => _status = value);
                  }
                },
                hint: Text(_status ?? 'Select Status'),
                validator: (value) => value == null ? 'Please select a status' : null,
              ),
              const SizedBox(height: 8),
              /*FutureBuilder<List<String>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final users = snapshot.data ?? [];

                  // Check if the assigned user is in the list, if so, set that value
                  String? defaultAssignedUser = users.contains(_assignedUserName) ? _assignedUserName : null;

                  return DropdownButtonFormField<String>(
                    value: defaultAssignedUser,
                    decoration: const InputDecoration(labelText: 'Assign User'),
                    items: users
                        .map((user) => DropdownMenuItem<String>(
                      value: user,
                      child: Text(user),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _assignedUserName = value;
                      });
                    },
                    hint: const Text('Select User'),
                    validator: (value) => value == null ? 'Please select a user' : null,
                  );
                },
              ),*/
              const SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: _submitTestCaseForm,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}