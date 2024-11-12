import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../custom_widgets/scenario_list.dart';
import '../custom_widgets/add_scenario_form.dart';
import '../../models/scenario.dart';

class RoleBasedUI extends StatelessWidget {
  final UserModel? userModel;
  final List<Scenario> scenarios;
  final Function(Scenario scenario) onAddScenario;

  const RoleBasedUI({
    super.key,
    required this.userModel,
    required this.scenarios,
    required this.onAddScenario,
  });

  Widget _buildUIForRole(BuildContext context, String role) {
    switch (role) {
      case 'Junior Tester':
      case 'Tester Lead':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScenarioList(userModel: userModel!),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddScenarioForm(
                    onScenarioAdded: onAddScenario,
                    userModel: userModel!,
                  ),
                );
              },
              child: const Text('Add New Scenario'),
            ),
            const SizedBox(height: 10),
          ],
        );
      default:
        return const Center(child: Text('Role not recognized.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userModel?.designation != null) {
      return _buildUIForRole(context, userModel!.designation!);
    }
    return const Center(child: Text('User model is not available.'));
  }
}
