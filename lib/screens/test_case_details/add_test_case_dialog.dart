import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../firebase/firestore_services.dart';
import '../../models/scenario.dart';
import '../../models/test_cases.dart';
import '../../models/user_model.dart';

class AddTestCaseDialog extends StatefulWidget {
  final Scenario? scenario;
  final UserModel? userModel;
  final VoidCallback onTestCaseAdded;

  const AddTestCaseDialog({
    super.key,
    this.scenario,
    this.userModel,
    required this.onTestCaseAdded,
  });

  @override
  State<AddTestCaseDialog> createState() => _AddTestCaseDialogState();
}

class _AddTestCaseDialogState extends State<AddTestCaseDialog> {
  final FirestoreService firestoreService = FirestoreService();
  final GlobalKey<FormState> _testCaseFormKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  String? _status;
  String? _assignedUserName;
  Uint8List? fileBytes;
  String fileName = "";

  // Future to fetch the list of users for assignment
  Future<List<String>>? _usersFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the list of users
    _usersFuture = firestoreService.getAssignedUsers();
  }

  Future<void> _submitTestCaseForm() async {
    if (_testCaseFormKey.currentState?.validate() ?? false) {
      final testCase = TestCase(
        id: _idController.text,
        name: _nameController.text,
        status: _status ?? 'In-Review',
        description: _descriptionController.text,
        comments: _commentsController.text,
        attachment: fileName,
        scenarioId: widget.scenario!.id,
        assignedBy: widget.userModel?.email ?? 'default@email.com',
        assignedUsers: _assignedUserName ?? '',
      );

      // Add the test case to Firestore
      await firestoreService.addTestCase(widget.scenario!.projectID, widget.scenario!.id, testCase);

      // Call the callback to refresh the list
      widget.onTestCaseAdded();

      // Close the dialog
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickAndUploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true);
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No file picked')));
      return;
    }
    setState(() {
      fileBytes = result.files.first.bytes;
      fileName = result.names.first!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Test Case'),
      content: SingleChildScrollView(
        child: Form(
          key: _testCaseFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'Test Case ID'),
                validator: (value) => value!.isEmpty ? 'Please enter a test case id' : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Test Case Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a test case name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),

              // Dropdown to assign a user
              FutureBuilder<List<String>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final users = snapshot.data ?? [];
                  return DropdownButtonFormField<String>(
                    value: _assignedUserName,
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
              ),

              ElevatedButton(onPressed: _pickAndUploadImage, child: const Text('Upload File')),
              ElevatedButton(onPressed: _submitTestCaseForm, child: const Text('Save Test Case')),
            ],
          ),
        ),
      ),
    );
  }
}
