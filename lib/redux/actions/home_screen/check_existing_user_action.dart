import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/redux/actions/loading_actions/is_loaded.dart';

import '../../../constants/hive_service.dart';
import '../../../models/user_model.dart';
import '../../app_state.dart';
import '../loading_actions/is_loading.dart';

///Check CheckExistingUser Action
class CheckExistingUserAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    UserModel? userModel = await HiveService().getUser();
    return state.copy(userModel: userModel);
  }

  @override
  void before() {
    dispatch(IsLoading());
    super.before();
  }

  @override
  void after() {
    dispatch(IsLoaded());
    super.after();
  }
}
