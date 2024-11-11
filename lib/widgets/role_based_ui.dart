import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'scenario_list.dart';
import 'add_scenario_form.dart';
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

  @override
  Widget build(BuildContext context) {
    if (userModel?.designation == 'Junior Tester') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('Add New Test Case'),
          ),
          const SizedBox(height: 10),
          const Text('Filter Test Cases:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ScenarioList(email: '${userModel!.email}'),
        ],
      );
    } else if (userModel?.designation == 'Tester Lead') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddScenarioForm(onScenarioAdded: onAddScenario,userModel: userModel!,),
              );
            },
            child: const Text('Add New Scenario'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('View Last 10 Updates'),
          ),
          const SizedBox(height: 10),
          ScenarioList(email: '${userModel!.email}',),
        ],
      );
    }
    return const Center(child: Text('Role not recognized.'));
  }
}
