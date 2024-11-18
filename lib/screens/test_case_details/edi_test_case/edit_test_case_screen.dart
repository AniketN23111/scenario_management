import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scenario_management/constants/enums.dart';
import 'package:scenario_management/custom_widgets/custom_text_form_field.dart';
import 'package:scenario_management/models/scenario.dart';
import 'package:scenario_management/models/status_change_log.dart';
import 'package:scenario_management/screens/test_case_details/edi_test_case/widgets/add_comment_field.dart';
import 'package:scenario_management/screens/test_case_details/edi_test_case/widgets/comments_section.dart';
import 'package:scenario_management/screens/test_case_details/edi_test_case/widgets/status_changes_section.dart';
import 'package:scenario_management/screens/test_case_details/edi_test_case/widgets/status_dropdown.dart';
import '../../../models/comments.dart';
import '../../../models/test_cases.dart';
import '../../../models/user_model.dart';

class EditTestCaseScreen extends StatefulWidget {
  final TestCase testCase;
  final UserModel userModel;
  final Scenario scenario;
  final UserRole userRole;
  final void Function(Scenario scenario, TestCase updatedTestCase)
      updateTestCase;
  final void Function(String testCaseId, Map<String, dynamic> commentData)
      addComment;
  final void Function(String testCaseId, Map<String, dynamic> statusChangeData)
      statusUpdate;
  final void Function(String testCaseId) getCommentList;
  final void Function(String testCaseId) statusUpdateList;
  final List<StatusChange> statusChangeList;
  final List<Comments> commentList;

  const EditTestCaseScreen(
      {super.key,
      required this.testCase,
      required this.scenario,
      required this.userModel,
      required this.userRole,
      required this.updateTestCase,
      required this.addComment,
      required this.statusUpdate,
      required this.statusChangeList,
      required this.commentList,
      required this.getCommentList,
      required this.statusUpdateList});

  @override
  _EditTestCaseScreenState createState() => _EditTestCaseScreenState();
}

class _EditTestCaseScreenState extends State<EditTestCaseScreen> {
  // Text controllers to edit test case fields
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String? _status;
  String? _assignedUserName;
  final TextEditingController _commentController = TextEditingController();
  Future<List<Comments>> list = Future.value([]);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.testCase.name);
    _descriptionController =
        TextEditingController(text: widget.testCase.description);
    _status = widget.testCase.status;
    _assignedUserName = widget.testCase.assignedUsers;
    fetchInitComment();
  }

  Future<void> fetchInitComment() async {
    widget.getCommentList(widget.testCase.id!);
    widget.statusUpdateList(widget.testCase.id!);
  }

  ///After submit Form
  Future<void> _submitTestCaseForm() async {
    // Check if the form is valid before submitting
    if (_nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _status != null) {
      // Ask the user if they want to update the status
      if (_status != widget.testCase.status) {
        bool updateStatusConfirmed = await _showUpdateStatusDialog();
        if (!updateStatusConfirmed) return; // If user cancels, don't proceed
      }

      // Create the updated test case object
      TestCase updatedTestCase = TestCase(
        id: widget.testCase.id,
        // Keep the same ID
        name: _nameController.text,
        status: _status!,
        description: _descriptionController.text,
        attachment: widget.testCase.attachment,
        scenarioId: widget.testCase.scenarioId,
        assignedBy: widget.testCase.assignedBy,
        assignedUsers: _assignedUserName ?? widget.testCase.assignedUsers,
      );

      // Update Test Cases
      widget.updateTestCase(widget.scenario, updatedTestCase);

      // If status was updated, store the status change in the new collection
      if (_status != widget.testCase.status) {
        await _storeStatusChange(updatedTestCase);
      }

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

  Future<void> _addComment() async {
    if (_commentController.text.isNotEmpty) {
      final commentData = {
        'id': widget.testCase.id,
        'text': _commentController.text,
        'createdBy': widget.userModel.name,
        'createdAt': FieldValue.serverTimestamp(),
      };
      widget.addComment(widget.testCase.id!, commentData);
      _commentController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty')),
      );
    }
  }

  Future<bool> _showUpdateStatusDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Update Status'),
              content: const Text(
                  'Do you want to update the status of this test case?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancel the update
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Confirm the update
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        ) ??
        false; // If dialog is dismissed, return false by default
  }

// Method to store the status change in a new Firestore collection
  Future<void> _storeStatusChange(TestCase updatedTestCase) async {
    // Create a new document in the "status_updates" collection
    final statusChangeData = {
      'status': updatedTestCase.status,
      'testCaseId': updatedTestCase.id,
      'scenarioId': widget.scenario.id,
      'createdBy': widget.userModel.name,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      widget.statusUpdate(widget.testCase.id!, statusChangeData);
    } catch (e) {
      print('Error storing status update: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Edit Test Case: ${widget.testCase.name}(${widget.testCase.id})'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Test Case Name (Form Field)
              buildTextFormField(
                enabled: true,
                controller: _nameController,
                label: 'Test Case Name',
                hintText: 'Enter Test Case Name',
              ),
              const SizedBox(height: 8),

              // Description (Form Field)
              buildTextFormField(
                enabled: true,
                controller: _descriptionController,
                label: 'Description',
                hintText: 'Enter Description',
                maxLines: 4,
              ),
              const SizedBox(height: 8),

              // Status Dropdown (Form Field)
              StatusDropdown(
                status: _status,
                userRole: widget.userRole,
                onStatusChanged: (newStatus) {
                  setState(() {
                    _status = newStatus;
                  });
                },
              ),
              const SizedBox(height: 8),

              ExpansionTile(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.grey[300],
                collapsedBackgroundColor: Colors.grey[300],
                collapsedShape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12)),
                title: const Text('Chat '),
                leading: const Icon(Icons.chat),
                children: [
                  CommentsSection(
                    commentList: widget.commentList,
                    userModel: widget.userModel,
                  ),
                  const SizedBox(height: 16),

                  // Add Comment Field
                  AddCommentField(
                    controller: _commentController,
                    onAddComment: _addComment,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              const SizedBox(height: 16),
              // Expanded Status Changes Section
              if (widget.userRole == UserRole.testerLead)
                ExpansionTile(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.grey[300],
                  collapsedBackgroundColor: Colors.grey[300],
                  collapsedShape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(12)),
                  title: const Text('Status Changes'),
                  leading: const Icon(Icons.update),
                  children: [
                    // _buildStatusChangesSection(),
                    StatusChangesSection(
                      statusChangeList:
                          widget.statusChangeList.take(10).toList(),
                    ),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitTestCaseForm,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}
