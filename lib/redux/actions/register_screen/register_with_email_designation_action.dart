import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/models/user_model.dart';

import '../../../constants/hive_service.dart';
import '../../app_state.dart';
import '../loading_actions/is_loaded.dart';
import '../loading_actions/is_loading.dart';

/// Register with Email and Designation Action
class RegisterWithEmailDesignationAction extends ReduxAction<AppState> {
  final String email;
  final String password;
  final String designation;
  final String name;

  RegisterWithEmailDesignationAction({
    required this.email,
    required this.password,
    required this.designation,
    required this.name,
  });

  @override
  Future<AppState?> reduce() async {
    try {
      UserModel userModel = await FirestoreService().registerUser(email, password, name, designation);
      // Save UserModel using HiveService
      await HiveService().saveUser(userModel);
      return state.copy(err: null,userModel: userModel);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "An account already exists with that email.";
      } else {
        errorMessage = "Failed to register: ${e.message}";
      }
      return state.copy(err: errorMessage,userModel: UserModel());
    }
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
