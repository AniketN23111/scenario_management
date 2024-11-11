import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scenario_management/constants/hive_service.dart';


import '../../../models/user_model.dart';
import '../../app_state.dart';

///SignOut Action
class MyHomePageSignOutAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    await HiveService().clearUser();
    await FirebaseAuth.instance.signOut();
    return state.copy(userModel: UserModel());
  }
}
