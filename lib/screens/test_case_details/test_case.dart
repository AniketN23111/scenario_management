import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:scenario_management/models/user_model.dart';
import '../../firebase/firestore_services.dart';
import '../../models/scenario.dart';
import '../../models/test_cases.dart';

class TestCaseScreen extends StatefulWidget {
  final Scenario? scenario;
  final UserModel? userModel;

  const TestCaseScreen({super.key, this.scenario, this.userModel});

  @override
  State<TestCaseScreen> createState() => _TestCaseScreenState();
}

class _TestCaseScreenState extends State<TestCaseScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final GlobalKey<FormState> _testCaseFormKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bugIdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  String? _status;
  String? _assignedUserName;
  bool _isEditing = false;
  String? _editingTestCaseId;
  Uint8List? fileBytes;
  String fileName = "";

  Future<List<String>>? _usersFuture;
  String? _userDesignation;

  @override
  void initState() {
    super.initState();
    _usersFuture = firestoreService.getUserNames();
    _initUserDesignation();
  }

  Future<void> _initUserDesignation() async {
    _userDesignation = widget.userModel!.designation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.scenario!.project} - ${widget.scenario!.name}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<TestCase>>(
              future: firestoreService.getTestCasesByScenario(widget.scenario!.id),
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
                  shrinkWrap: true,
                  itemCount: testCases.length,
                  itemBuilder: (context, index) {
                    final testCase = testCases[index];
                    return ListTile(
                      title: Text('TestCase Name: ${testCase.name}'),
                      subtitle: Text('Status: ${testCase.status}'),
                      trailing: Text('Bug ID: ${testCase.bugId}'),
                      onTap: () => _editTestCase(testCase),
                    );
                  },
                );
              },
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _testCaseFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing ? 'Edit Test Case' : 'Add New Test Case',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      TextFormField(
                        controller: _idController,
                        decoration: const InputDecoration(labelText: 'Test Case ID'),
                        validator: (value) => value!.isEmpty ? 'Please enter a test case id' : null,
                        readOnly: _isEditing,
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Test Case Name'),
                        validator: (value) => value!.isEmpty ? 'Please enter a test case name' : null,
                      ),
                      TextFormField(
                        controller: _bugIdController,
                        decoration: const InputDecoration(labelText: 'Bug ID'),
                        validator: (value) => value!.isEmpty ? 'Please enter a Bug ID' : null,
                      ),
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
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                        validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                      ),
                      TextFormField(
                        controller: _commentsController,
                        decoration: const InputDecoration(labelText: 'Comment'),
                        validator: (value) => value!.isEmpty ? 'Please enter a Comment' : null,
                      ),
                      ElevatedButton(
                          onPressed: _pickAndUploadImage,
                          child: const Text('Upload File')),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitTestCaseForm,
                        child: Text(_isEditing ? 'Update Test Case' : 'Save Test Case'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitTestCaseForm() {
    if (_testCaseFormKey.currentState?.validate() ?? false) {
      final testCase = TestCase(
        id: _idController.text,
        name: _nameController.text,
        bugId: _bugIdController.text,
        status: _status!,
        description: _descriptionController.text,
        comments: _commentsController.text.toString(),
        attachment: '',
        scenarioId: widget.scenario!.id,
        assignedBy: widget.userModel?.email ?? 'default@email.com',
        assignedUsers: _assignedUserName ?? '',
      );

      if (_isEditing) {
        firestoreService.updateTestCase(widget.scenario!.id, testCase);
      } else {
        firestoreService.addTestCase(widget.scenario!.id, testCase);
      }

      setState(() {
        _isEditing = false;
        _editingTestCaseId = null;
      });
      _clearTestCaseForm();
    }
  }

  void _editTestCase(TestCase testCase) {
    setState(() {
      _isEditing = true;
      _editingTestCaseId = testCase.id;
      _idController.text = testCase.id;
      _nameController.text = testCase.name;
      _bugIdController.text = testCase.bugId;
      _status = testCase.status;
      _descriptionController.text = testCase.description;
    });
  }

  void _clearTestCaseForm() {
    _idController.clear();
    _nameController.clear();
    _bugIdController.clear();
    _descriptionController.clear();
    _commentsController.clear();
    setState(() {
      _status = null;
      _assignedUserName = null;
    });
  }

  Future<void> _pickAndUploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true);
    if (result == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file picked')),
      );
      return;
    }
    setState(() {
      fileBytes = result.files.first.bytes;
      fileName = result.names.first!;
    });
  }
}
