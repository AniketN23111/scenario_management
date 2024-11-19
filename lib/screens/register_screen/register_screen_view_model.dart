import 'package:async_redux/async_redux.dart';
import 'package:scenario_management/TypeDef/type_def.dart';
import 'package:scenario_management/screens/register_screen/register_screen_connector.dart';

import '../../redux/actions/register_screen/register_with_email_designation_action.dart';
import '../../redux/app_state.dart';
import '../../route_names/route_names.dart';

class RegisterScreenViewModel extends Vm {
  final bool isLoading;
  final String err;
  final RegisterWithEmailAndDesignationTypeDef
      registerWithEmailAndDesignationTypeDef;


  RegisterScreenViewModel(
      {required this.isLoading,
        required this.err,
      required this.registerWithEmailAndDesignationTypeDef})
      : super(equals: [isLoading]);
}

class Factory extends VmFactory<AppState, RegisterScreenConnector,
    RegisterScreenViewModel> {
  Factory(connector) : super(connector);

  @override
  RegisterScreenViewModel? fromStore() => RegisterScreenViewModel(
      isLoading: state.loading,
      err: state.err,
      registerWithEmailAndDesignationTypeDef:
          (String email, String password, String designation, String name) {
        dispatch(RegisterWithEmailDesignationAction(
            email: email,
            password: password,
            designation: designation,
            name: name));

        /// If successful, navigate to the login route
        dispatch(NavigateAction.pushNamed(RoutesName.loginScreen));
      });
}
