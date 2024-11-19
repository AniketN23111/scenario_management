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
  final String? name;

  @HiveField(3)
  final String? designation;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.designation,
  });
  //UserModel.empty();

  /// Factory method to create UserModel from a map (Firestore document data)
  factory UserModel.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return UserModel(); // Return an empty UserModel if data is null
    }

    return UserModel(
      uid: data['uid'] as String? ?? '',
      email: data['email'] as String? ?? '',
      name: data['name'] as String? ?? '',
      designation: data['designation'] as String? ?? '',
    );
  }

  /// Method to create a UserModel from Firebase User and additional data
  factory UserModel.fromFirebaseUser(User? user, String? designation, String? name) {
    if (user == null) {
      return UserModel(); // Return an empty UserModel if user is null
    }

    return UserModel(
      uid: user.uid ,
      email: user.email ?? '',
      name: name ?? '',
      designation: designation ?? '',
    );
  }
}
