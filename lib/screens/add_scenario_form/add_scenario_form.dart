import 'package:flutter/material.dart';
import 'package:scenario_management/models/user_model.dart';
import 'package:scenario_management/models/scenario.dart';
import 'package:scenario_management/utility/no_space_formatter.dart';

class AddScenarioForm extends StatefulWidget {
  final UserModel userModel;
  final Scenario scenario;
  final void Function(Scenario scenario) addScenario;
  final void Function(String projectName) createProject;
  final List<Map<String, dynamic>> projects;
  final void Function() fetchProjects;

  const AddScenarioForm(
      {super.key,
      required this.userModel,
      required this.scenario,
      required this.addScenario,
      required this.createProject,
      required this.fetchProjects,
      required this.projects});

  @override
  _AddScenarioFormState createState() => _AddScenarioFormState();
}

class _AddScenarioFormState extends State<AddScenarioForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _newProjectController = TextEditingController();

  String? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    widget.fetchProjects();
  }

  Future<void> _createNewProject() async {
    if (_newProjectController.text.isNotEmpty) {
      // Create new project
       widget.createProject(_newProjectController.text);

      // Wait for projects to be updated
      widget.fetchProjects();

      // Delay until the fetch operation is completed (you may need a callback or a state update check here)
      Future.delayed(const Duration(milliseconds: 500), () {
        // Ensure the selected project ID is updated properly
        if (widget.projects.isNotEmpty) {
          setState(() {
            // Assign the last added project to the selected project ID
            _selectedProjectId = widget.projects.last['id'];
          });
        }

        // Clear the text field after creating a project
        _newProjectController.clear();
      });
    }
  }


  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final scenario = Scenario(
        id: _idController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        projectID: _selectedProjectId!,
        project: widget.projects
            .firstWhere((proj) => proj['id'] == _selectedProjectId)['name'],
        createdAt: DateTime.now(),
        createdBy: widget.userModel.email!,
      );

      widget.addScenario(scenario);
      await Future.delayed(const Duration(seconds: 2));
      widget.fetchProjects();
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
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Enter a scenario ID' : null,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Scenario Name'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Enter a scenario name' : null,
              inputFormatters: [
                NoSpacesFormatter()
              ],
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Project'),
              value: _selectedProjectId,
              items: widget.projects.map((project) {
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
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Enter a description' : null,
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
