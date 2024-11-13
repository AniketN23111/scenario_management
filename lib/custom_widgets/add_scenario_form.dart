import 'package:flutter/material.dart';
import 'package:scenario_management/models/user_model.dart';
import 'package:scenario_management/models/scenario.dart';

import '../firebase/firestore_services.dart';

class AddScenarioForm extends StatefulWidget {
  final Function(Scenario scenario) onScenarioAdded;
  final UserModel userModel;

  const AddScenarioForm({super.key, required this.onScenarioAdded, required this.userModel});

  @override
  _AddScenarioFormState createState() => _AddScenarioFormState();
}

class _AddScenarioFormState extends State<AddScenarioForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _newProjectController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService(); // FirestoreService instance
  String? _selectedProjectId;
  List<Map<String, dynamic>> _projects = [];

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    final projects = await _firestoreService.getProjects(); // Fetching projects
    setState(() {
      _projects = projects;
    });
  }

  Future<void> _createNewProject() async {
    if (_newProjectController.text.isNotEmpty) {
      await _firestoreService.createNewProject(_newProjectController.text); // Creating new project
      await _fetchProjects(); // Refresh the projects list after adding a new project
      _selectedProjectId = _projects.last['id']; // Automatically select the new project
      _newProjectController.clear();
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final scenario = Scenario(
        id: _idController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        projectID: _selectedProjectId!,
        project: _projects.firstWhere((proj) => proj['id'] == _selectedProjectId)['name'],
        createdAt: DateTime.now(),
        createdBy: widget.userModel.email!,
      );

      _firestoreService.addScenario(scenario); // Adding scenario to Firestore
      widget.onScenarioAdded(scenario);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Scenario'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'Scenario ID'),
              validator: (value) => value?.isEmpty ?? true ? 'Enter a scenario ID' : null,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Scenario Name'),
              validator: (value) => value?.isEmpty ?? true ? 'Enter a scenario name' : null,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Project'),
              value: _selectedProjectId,
              items: _projects.map((project) {
                return DropdownMenuItem<String>(
                  value: project['id'],
                  child: Text(project['name']),
                );
              }).toList()
                ..add(
                  const DropdownMenuItem<String>(
                    value: 'new_project',
                    child: Text('Create New Project'),
                  ),
                ),
              onChanged: (value) {
                setState(() {
                  if (value == 'new_project') {
                    _showCreateProjectDialog();
                  } else {
                    _selectedProjectId = value;
                  }
                });
              },
              validator: (value) => value == null ? 'Select a project' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) => value?.isEmpty ?? true ? 'Enter a description' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Add Scenario'),
        ),
      ],
    );
  }

  void _showCreateProjectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Project'),
          content: TextField(
            controller: _newProjectController,
            decoration: const InputDecoration(labelText: 'Project Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _createNewProject();
                Navigator.pop(context);
              },
              child: const Text('Create Project'),
            ),
          ],
        );
      },
    );
  }
}
