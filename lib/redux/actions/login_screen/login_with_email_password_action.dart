import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants/hive_service.dart';
import '../../../models/user_model.dart';
import '../../../route_names/route_names.dart';
import '../../app_state.dart';
import '../loading_actions/is_loaded.dart';
import '../loading_actions/is_loading.dart';

///Sign In with Email And Password Action in Login Screen
class LoginWithEmailPasswordAction extends ReduxAction<AppState> {
  late final String email;
  late final String password;

  LoginWithEmailPasswordAction({required this.email, required this.password});

  @override
  Future<AppState?> reduce() async {
    /// Sign in with email and password using FirebaseAuth
    final UserCredential credential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    /// Check if the user is valid
    User? currentUser = credential.user;

    if (currentUser != null) {
      // Fetch the user document from Firestore
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(
              'users')
          .doc(currentUser.uid)
          .get();

      // Retrieve designation from Firestore
      String designation = userDoc['designation'] ?? 'Unknown';
      // Retrieve name from Firestore
      String name = userDoc['name'] ?? 'Unknown';
      // Create UserModel from Firebase User
      final userModel = UserModel.fromFirebaseUser(currentUser, designation,name);
      // Save UserModel using HiveService
      await HiveService().saveUser(userModel);
      // Return updated state with userModel
      return state.copy(userModel: userModel);
    } else {
      // If no user, return state with default UserModel (empty)
      return state.copy(userModel: UserModel());
    }
  }

  @override
  void after() {
    dispatch(IsLoaded());
    /// If successful, navigate to the login route
    dispatch(NavigateAction.pushReplacementNamed(RoutesName.homePageScreen));
    super.after();
  }

  @override
  void before() {
    dispatch(IsLoading());
    super.before();
  }
}
