import 'package:flutter/material.dart';
import '../../firebase/firestore_services.dart';
import '../../constants/role_based_theme.dart';
import '../../models/user_model.dart';
import '../../widgets/role_based_ui.dart';
import '../../models/scenario.dart';
import '../../route_names/route_names.dart';

class HomeScreen extends StatefulWidget {
  final bool? isLoading;
  final UserModel? userModel;
  final void Function() signOut;
  final void Function() checkExistingUser;

  const HomeScreen({
    super.key,
    required this.isLoading,
    required this.userModel,
    required this.signOut,
    required this.checkExistingUser,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Scenario> _scenarios = [];

  @override
  void initState() {
    super.initState();
    widget.checkExistingUser();
    _fetchScenarios();
  }

  Future<void> _fetchScenarios() async {
    final scenarios = await _firestoreService.getScenarios();
    setState(() {
      _scenarios = scenarios;
    });
  }

  void _addScenario(Scenario scenario) async {
    await _firestoreService.addScenario(scenario);
    _fetchScenarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home - ${widget.userModel?.designation ?? 'User'}'),
        backgroundColor: roleColors[widget.userModel?.designation ?? 'Tester'],
      ),
      body: widget.isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : widget.userModel == null
          ? const Center(child: Text('No Data Found'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${widget.userModel!.email}', style: const TextStyle(fontSize: 16)),
            Text('Designation: ${widget.userModel!.designation}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Expanded(
              child: RoleBasedUI(
                userModel: widget.userModel,
                scenarios: _scenarios,
                onAddScenario: _addScenario,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.signOut();
                Navigator.pushNamed(context, RoutesName.loginScreen);
              },
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
