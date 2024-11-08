import 'package:async_redux/async_redux.dart';


import '../../models/user_model.dart';
import '../../redux/actions/my_home_page/home_page_signout_action.dart';
import '../../redux/app_state.dart';
import 'my_home_page_connector.dart';

class HomeScreenViewModel extends Vm {
  final bool isLoading;
  final UserModel userModel;
  late void Function() signOut;
  HomeScreenViewModel(
      {required this.isLoading, required this.userModel, required this.signOut})
      : super(equals: [isLoading, userModel]);
}

class Factory
    extends VmFactory<AppState, HomeScreenConnector, HomeScreenViewModel> {
  Factory(connector) : super(connector);

  @override
  HomeScreenViewModel? fromStore() => HomeScreenViewModel(
      isLoading: state.loading,
      userModel: state.userModel,
      signOut: () => dispatch(MyHomePageSignOutAction()));
}
