import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/main.dart';
import 'package:scenario_management/redux/actions/home_screen/get_project_action.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loading.dart';

import '../../app_state.dart';

///Check CheckExistingUser Action
class GetUserRoleAction extends ReduxAction<AppState> {
  final String roleID;
  GetUserRoleAction({required this.roleID});
  @override
  Future<AppState?> reduce() async {
    final role = await FirestoreService().fetchUserRole(roleID);
    themeManager.setRoleTheme(role);
    return state.copy(userRole: role);
  }

  @override
  void before() {
    dispatch(IsLoading());
    super.before();
  }

  @override
  void after() {
    dispatch(GetProjectAction());
    super.after();
  }
}
