
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../route_names/route_names.dart';


class HomeScreen extends StatefulWidget {
  final bool? isLoading;
  final UserModel? userModel;
  final void Function() signOut;
  const HomeScreen(
      {super.key,
        required this.isLoading,
        required this.userModel,
        required this.signOut});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: widget.isLoading == null || widget.isLoading == true
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : widget.userModel == null
            ? const Center(
          child: Text('No Data Found'),
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${widget.userModel!.email}'),
              Text('${widget.userModel!.designation}'),
              ElevatedButton(
                onPressed: (){
                  widget.signOut();
                  Navigator.pushNamed(context, RoutesName.loginScreen);
                },
                child: const Text('Log out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
