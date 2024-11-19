import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scenario_management/firebase/firestore_services.dart';

import '../../../constants/hive_service.dart';
import '../../../models/user_model.dart';
import '../../app_state.dart';
import '../home_screen/get_user_role_action.dart';
import '../loading_actions/is_loading.dart';

///Sign In with Email And Password Action in Login Screen
class LoginWithEmailPasswordAction extends ReduxAction<AppState> {
  final String email;
  final String password;
  String roleID='';

  LoginWithEmailPasswordAction({required this.email, required this.password});

  @override
  Future<AppState?> reduce() async {

    try{
      // Call createUser to fetch UserModel
      UserModel userModel = await FirestoreService().fetchUser(email, password);
      roleID =userModel.designation!;

      // Save UserModel using HiveService
      await HiveService().saveUser(userModel);

      // Return updated state with userModel
      return state.copy(userModel: userModel,err: null);
    }
    on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage ='No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage ='Wrong password';
      }
      else {
        errorMessage = "Failed to register: ${e.message}";
      }
      return state.copy(err: errorMessage,userModel: UserModel());
    }
  }

  @override
  void after() {
    dispatch(GetUserRoleAction(roleID: roleID));
    super.after();
  }

  @override
  void before() {
    dispatch(IsLoading());
    super.before();
  }
}
