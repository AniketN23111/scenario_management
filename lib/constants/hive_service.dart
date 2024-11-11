import 'package:hive/hive.dart';
import '../models/user_model.dart';

class HiveService {
  static const String _userBoxName = 'userBox';

  /// Singleton pattern for HiveService
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  /// Initialize Hive box
  Future<void> init() async {
    if (!Hive.isBoxOpen(_userBoxName)) {
      await Hive.openBox<UserModel>(_userBoxName);
    }
  }

  /// Get UserModel from Hive
  UserModel? getUser() {
    final userBox = Hive.box<UserModel>(_userBoxName);
    return userBox.get('user');
  }

  /// Save UserModel to Hive
  Future<void> saveUser(UserModel userModel) async {
    final userBox = Hive.box<UserModel>(_userBoxName);
    print(userModel);
    await userBox.put('user', userModel);
  }

  /// Delete UserModel from Hive
  Future<void> clearUser() async {
    final userBox = Hive.box<UserModel>(_userBoxName);
    await userBox.delete('user');
  }

  /// Check if UserModel exists in Hive (useful for splash screen)
  bool isUserLoggedIn() {
    final userBox = Hive.box<UserModel>(_userBoxName);
    return userBox.containsKey('user');
  }
}
