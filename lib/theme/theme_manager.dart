import 'package:flutter/material.dart';
import 'package:scenario_management/theme/theme_constants.dart';
import '../constants/enums.dart';


class ThemeManager extends ChangeNotifier with WidgetsBindingObserver {
  UserRole userRole = UserRole.admin;

  // Define custom themes for each role
  Map<UserRole, ThemeData> roleThemes = {
    UserRole.juniorTester: juniorTesterThemeData,
    UserRole.testerLead: testerLeadThemeData,
    UserRole.admin: adminThemeData
  };

  ThemeManager() {
    WidgetsBinding.instance.addObserver(this);
  }

  // Get the current theme based on user role
  ThemeData getCurrentRoleTheme() {
    return roleThemes[userRole] ?? roleThemes[UserRole.admin]!; // Default to admin theme
  }

  // Method to set the role and update the theme
  void setRoleTheme(UserRole role) {
    userRole = role;
    notifyListeners(); // Notify listeners to rebuild the theme
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
