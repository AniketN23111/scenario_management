import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/AsyncRedux/LoginScreen/login_screen_sign_in_with_email_and_password_action.dart';

import '../../TypeDef/type_def.dart';
import '../../app_state.dart';
import 'login_screen_connector.dart';

///Login Screen View Model
class LoginScreenViewModel extends Vm {
  final bool isLoading;
  final SignInWithEmailAndPasswordTypeDef signInWithEmailAndPasswordTypeDef;

  LoginScreenViewModel({
    required this.isLoading,
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
        signInWithEmailAndPasswordTypeDef: (String email, String password) {
          dispatch(LoginScreenSignInWithEmailAndPasswordAction(
              email: email, password: password));
        },
      );
}
