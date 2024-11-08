import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../route_names/route_names.dart';
import '../../app_state.dart';
import '../loading_actions/is_loaded.dart';
import '../loading_actions/is_loading.dart'; // Import Firestore package


/// Sign In with Email And Password Action in Login Screen
class RegisterWithEmailDesignationAction extends ReduxAction<AppState> {
  late final String email;
  late final String password;
  late final String designation;

  RegisterWithEmailDesignationAction(
      {required this.email, required this.password, required this.designation});

  @override
  Future<AppState?> reduce() async {
    try {
      /// Register user with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      /// Save additional user data (designation) to Firebase FireStore
      await FirebaseFirestore.instance
          .collection('designation')
          .doc(userCredential.user!.uid)
          .set({
        'email': email.trim(),
        'designation': designation,
      });

      /// If successful, navigate to the login route
      dispatch(NavigateAction.pushNamed(RoutesName.loginScreen));
    } on FirebaseAuthException catch (e) {
      // Handle specific errors here if needed
      if (e.code == 'weak-password') {
        throw const UserException("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        throw const UserException("An account already exists with that email.");
      } else {
        throw UserException("Failed to register: ${e.message}");
      }
    }
    return null;
  }

  @override
  void after() {
    dispatch(IsLoaded());
    super.after();
  }

  @override
  void before() {
    dispatch(IsLoading());
    super.before();
  }
}
