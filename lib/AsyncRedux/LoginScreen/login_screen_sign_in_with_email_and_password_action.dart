import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../RouteNames/route_names.dart';
import '../../app_state.dart';

///Sign In with Email And Password Action in Login Screen
class LoginScreenSignInWithEmailAndPasswordAction extends ReduxAction<AppState> {
  late final String email;
  late final String password;

  LoginScreenSignInWithEmailAndPasswordAction({required this.email, required this.password});

  @override
  Future<AppState?> reduce() async {
    try {
      /// Sign in with email and password using FirebaseAuth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      /// If successful, navigate to the home route
      dispatch(NavigateAction.pushNamed(RoutesName.homePageScreen));
    } on FirebaseAuthException catch (e) {
      /// Handle specific errors here if needed
      if (e.code == 'wrong-password') {
        throw const UserException("Incorrect password.");
      } else if (e.code == 'user-not-found') {
        throw const UserException("No user found with this email.");
      } else {
        throw UserException("Failed to sign in: ${e.message}");
      }
    }
    return null;
  }
}