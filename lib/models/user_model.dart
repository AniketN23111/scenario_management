import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0) // Ensure typeId is unique within your app
class UserModel extends HiveObject {
  @HiveField(0)
  final String? uid;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String? designation;

  UserModel({ this.uid, this.email, this.designation});

  // Method to create a UserModel from Firebase User and additional data
  factory UserModel.fromFirebaseUser(User user, String designation) {
    return UserModel(
      uid: user.uid,
      email: user.email!,
      designation: designation,
    );
  }
}
