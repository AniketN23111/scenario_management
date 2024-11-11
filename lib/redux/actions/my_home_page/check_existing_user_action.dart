import 'dart:async';

import 'package:async_redux/async_redux.dart';

import '../../../constants/hive_service.dart';
import '../../../models/user_model.dart';
import '../../app_state.dart';

///Check CheckExistingUser Action
class CheckExistingUserAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    UserModel? userModel = await HiveService().getUser();
    return state.copy(userModel: userModel);
  }
}
