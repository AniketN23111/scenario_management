import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:scenario_management/redux/app_state.dart';
import 'package:scenario_management/screens/register_screen/register_screen.dart';
import 'package:scenario_management/screens/register_screen/register_screen_view_model.dart';

class RegisterScreenConnector extends StatelessWidget {
  final bool? isLoading;

  const RegisterScreenConnector({super.key, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RegisterScreenViewModel>(
      vm: () => Factory(this),
      builder: (context, vm) => RegisterScreen(
        isLoading: vm.isLoading,
        registerWithEmailAndDesignationTypeDef:
            (String email, String password, String designation) {
          vm.registerWithEmailAndDesignationTypeDef(
              email, password, designation);
        },
      ),
    );
  }
}
