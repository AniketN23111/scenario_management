import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/redux/actions/my_home_page/check_existing_user_action.dart';

import '../../models/user_model.dart';
import '../../redux/actions/my_home_page/home_page_signout_action.dart';
import '../../redux/app_state.dart';
import 'home_screen_connector.dart';

class HomeScreenViewModel extends Vm {
  final bool isLoading;
  final UserModel userModel;
  late final void Function() signOut;
  late final void Function() checkExistingUser;

  HomeScreenViewModel(
      {required this.isLoading,
      required this.userModel,
      required this.signOut,
      required this.checkExistingUser})
      : super(equals: [isLoading, userModel]);
}

class Factory
    extends VmFactory<AppState, HomeScreenConnector, HomeScreenViewModel> {
  Factory(connector) : super(connector);

  @override
  HomeScreenViewModel? fromStore() => HomeScreenViewModel(
      isLoading: state.loading,
      userModel: state.userModel,
      signOut: () => dispatch(MyHomePageSignOutAction()),
      checkExistingUser: () => dispatch(CheckExistingUserAction()));
}
