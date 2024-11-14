import 'package:flutter/material.dart';
import '../../../constants/role_based_theme.dart';
import '../../../models/scenario.dart';
import '../../../models/test_cases.dart';
import '../../../models/user_model.dart';
import '../../../route_names/route_names.dart';
import '../add_test_case_dialog.dart';

class TestCaseScreen extends StatefulWidget {
  final Scenario? scenario;
  final UserModel? userModel;
  final Future<List<TestCase>> listTestCase;
  final void Function(Scenario scenario) getTestCaseByScenario;

  const TestCaseScreen({
    super.key,
    required this.scenario,
    required this.userModel,
    required this.listTestCase,
    required this.getTestCaseByScenario,
  });

  @override
  State<TestCaseScreen> createState() => _TestCaseScreenState();
}

class _TestCaseScreenState extends State<TestCaseScreen> {
  String? selectedAssignedBy;
  String? selectedAssignedUser;
  String searchQuery = '';
  String selectedSearchField = 'name';
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.getTestCaseByScenario(widget.scenario!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: roleColors[widget.userModel?.designation ?? 'Tester'],
        title: Text('${widget.scenario!.project} - ${widget.scenario!.name}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    // Dropdown for selecting search field
                    Expanded(
                      flex: 2,
                      child: DropdownButton<String>(
                        style: const TextStyle(color: Colors.black),
                        value: selectedSearchField,
                        items: const [
                          DropdownMenuItem(value: 'name', child: Text('Name')),
                          DropdownMenuItem(
                              value: 'status', child: Text('Status')),
                          DropdownMenuItem(
                              value: 'assignedBy', child: Text('Assigned By')),
                          DropdownMenuItem(
                              value: 'assignedUsers',
                              child: Text('Assigned Users')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedSearchField = value!;
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Search input field
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _searchController,
                        onEditingComplete: () {
                          setState(() {
                            searchQuery = _searchController.text;
                          });
                          _refreshTestCases();
                        },
                        decoration: InputDecoration(
                          hintText: "Search Test Cases...",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      searchQuery = '';
                                      _searchController.clear();
                                    });
                                    _refreshTestCases();
                                  },
                                )
                              : null,
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<TestCase>>(
        future: widget.listTestCase,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final testCases = snapshot.data ?? [];
          if (testCases.isEmpty) {
            return const Center(
                child: Text('No test cases found for this scenario.'));
          }

          // Apply the filtering logic
          final filteredTestCases = _applyFilters(testCases);

          return ListView.builder(
            itemCount: filteredTestCases.length,
            itemBuilder: (context, index) {
              final testCase = filteredTestCases[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    'TestCase: ${testCase.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Status: ${testCase.status}',
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                  trailing: Chip(
                    label: Text('ID: ${testCase.id}'),
                    backgroundColor: Colors.red,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    RoutesName.editTestCaseScreen,
                    arguments: testCase,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTestCaseDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Apply filtering to the test cases list
  List<TestCase> _applyFilters(List<TestCase> testCases) {
    final queryFiltered = testCases.where((testCase) {
      bool matchesSearchQuery =
          searchQuery.isEmpty || _fieldMatchesSearchQuery(testCase);
      bool matchesAssignedBy = selectedAssignedBy == null ||
          testCase.assignedBy == selectedAssignedBy;
      bool matchesAssignedUser = selectedAssignedUser == null ||
          testCase.assignedUsers == selectedAssignedUser;
      return matchesSearchQuery && matchesAssignedBy && matchesAssignedUser;
    }).toList();
    return queryFiltered;
  }

  // Helper method to match the selected field with the search query
  bool _fieldMatchesSearchQuery(TestCase testCase) {
    switch (selectedSearchField) {
      case 'name':
        return testCase.name!.toLowerCase().contains(searchQuery.toLowerCase());
      case 'status':
        return testCase.status!
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      case 'assignedBy':
        return testCase.assignedBy!
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      case 'assignedUsers':
        return testCase.assignedUsers!
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      default:
        return false;
    }
  }

  // Refresh the list of test cases based on the new filter
  void _refreshTestCases() {
    setState(() {
      widget.getTestCaseByScenario(widget.scenario!);
    });
  }

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
}
