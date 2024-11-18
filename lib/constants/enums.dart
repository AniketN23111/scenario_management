enum UserRole {
  juniorTester,
  testerLead,
  admin,
  // Add other roles as needed
}

extension UserRoleExtension on UserRole {
  static UserRole fromString(String role) {
    switch (role) {
      case 'Junior Tester':
        return UserRole.juniorTester;
      case 'Tester Lead':
        return UserRole.testerLead;
      default:
        return UserRole.admin;
    }
  }
}
extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}

