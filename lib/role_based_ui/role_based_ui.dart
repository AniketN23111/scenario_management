import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class RoleBasedUI extends StatelessWidget {
  final UserModel? userModel;

  const RoleBasedUI({
    super.key,
    required this.userModel,

  });

  Widget _buildUIForRole(BuildContext context, String role) {
    switch (role) {
      case 'Junior Tester':
      case 'Tester Lead':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 10),
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
