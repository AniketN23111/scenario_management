import 'package:flutter/material.dart';
import 'package:scenario_management/models/user_model.dart';
import '../../models/scenario.dart';

class AddScenarioForm extends StatefulWidget {
  final Function(Scenario scenario) onScenarioAdded;
  final UserModel userModel;

  const AddScenarioForm({super.key, required this.onScenarioAdded,required this.userModel});

  @override
  _AddScenarioFormState createState() => _AddScenarioFormState();
}

class _AddScenarioFormState extends State<AddScenarioForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final scenario = Scenario(
        id: _idController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        project: _projectController.text,
        createdAt: DateTime.now(),
        createdBy: widget.userModel.email!,
      );
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
              validator: (value) => value?.isEmpty ?? true ? 'Enter a scenario id' : null,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Scenario Name'),
              validator: (value) => value?.isEmpty ?? true ? 'Enter a scenario name' : null,
            ),
            TextFormField(
              controller: _projectController,
              decoration: const InputDecoration(labelText: 'Project'),
              validator: (value) => value?.isEmpty ?? true ? 'Enter a project' : null,
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
}
