import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/models/user_model.dart';

import '../../TypeDef/type_def.dart';
import '../../redux/actions/login_screen/login_with_email_password_action.dart';
import '../../redux/app_state.dart';
import 'login_screen_connector.dart';

///Login Screen View Model
class LoginScreenViewModel extends Vm {
  final bool isLoading;
  final String err;
  final UserModel userModel;
  final SignInWithEmailAndPasswordTypeDef signInWithEmailAndPasswordTypeDef;

  LoginScreenViewModel({
    required this.isLoading,
    required this.err,
    required this.userModel,
    required this.signInWithEmailAndPasswordTypeDef,
  }) : super(equals: [isLoading]);
}

///Login Screen Factory Method
class Factory
    extends VmFactory<AppState, LoginScreenConnector, LoginScreenViewModel> {
  Factory(connector) : super(connector);

  @override
  LoginScreenViewModel fromStore() => LoginScreenViewModel(
        isLoading: state.loading,
        err: state.err,
        userModel: state.userModel,
        signInWithEmailAndPasswordTypeDef: (String email, String password) {
          dispatch(LoginWithEmailPasswordAction(
              email: email, password: password));
        },
      );
}
