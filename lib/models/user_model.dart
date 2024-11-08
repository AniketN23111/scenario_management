import 'package:firebase_auth/firebase_auth.dart';

///Model For Storing the Basic Details of User
class UserModel {
  String? id;
  String? email;
  String? name;
  String? designation;

  UserModel({this.id, this.email, this.name,this.designation});

  /// Method to create a UserModel from Firebase User
  factory UserModel.fromFirebaseUser(User user,String designation) {
    return UserModel(
      email: user.email,
      name: user.displayName,
      id: user.uid,
      designation: designation,
    );
  }
}
