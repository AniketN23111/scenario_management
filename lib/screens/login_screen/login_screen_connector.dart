import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

import '../../redux/app_state.dart';
import 'login_page.dart';
import 'login_screen_view_model.dart';

///Login Screen Connector
class LoginScreenConnector extends StatelessWidget {
  final bool? isLoading;

  const LoginScreenConnector({super.key, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginScreenViewModel>(
      vm: () => Factory(this),
      builder: (context, vm) => LoginScreen(
        isLoading: vm.isLoading,
        signInWithEmailAndPassword: (String email, String password) {
          vm.signInWithEmailAndPasswordTypeDef(email,password);
        },
      ),
    );
  }
}

