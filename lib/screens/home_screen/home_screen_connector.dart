import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:scenario_management/redux/app_state.dart';
import 'package:scenario_management/screens/home_screen/home_screen.dart';

import '../../models/user_model.dart';
import 'home_screen_view_model.dart';

class HomeScreenConnector extends StatelessWidget {
  final bool? isLoading;
  final UserModel? userModel;

  const HomeScreenConnector({super.key, this.isLoading, this.userModel});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,HomeScreenViewModel>(
      vm: () => Factory(this),
      builder: (context, vm) => HomeScreen(
        isLoading: vm.isLoading,
        userModel: vm.userModel,
        signOut: vm.signOut,
        checkExistingUser: vm.checkExistingUser,
      ),
    );
  }
}
