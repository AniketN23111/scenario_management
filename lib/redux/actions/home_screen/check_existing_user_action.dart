import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/redux/actions/home_screen/get_user_role_action.dart';

import '../../../constants/hive_service.dart';
import '../../../models/user_model.dart';
import '../../app_state.dart';
import '../loading_actions/is_loading.dart';

///Check CheckExistingUser Action
class CheckExistingUserAction extends ReduxAction<AppState> {
  String roleID = '';

  @override
  Future<AppState?> reduce() async {
    // Retrieve UserModel from HiveService
    UserModel? userModel = await HiveService().getUser();

    // Handle the case where no UserModel exists
    if (userModel == null) {
      return null;
    }

    // Extract role ID
    roleID = userModel.designation ?? '';

    // Return the updated state with the userModel
    return state.copy(userModel: userModel);
  }

  @override
  void before() {
    dispatch(IsLoading());
    super.before();
  }

  @override
  void after() {
    if (roleID.isNotEmpty) {
      // Dispatch role-specific actions if roleID is valid
      dispatch(GetUserRoleAction(roleID: roleID));
    }
    super.after();
  }
}

