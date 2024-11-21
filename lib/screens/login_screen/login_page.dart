import 'package:flutter/material.dart';
import 'package:scenario_management/custom_widgets/custom_button.dart';
import 'package:scenario_management/models/user_model.dart';
import 'package:scenario_management/utility/no_space_formatter.dart';

import '../../TypeDef/type_def.dart';
import '../../route_names/route_names.dart';

class LoginScreen extends StatefulWidget {
  final bool? isLoading;
  final String err;
  final UserModel userModel;
  final SignInWithEmailAndPasswordTypeDef signInWithEmailAndPassword;

  const LoginScreen(
      {super.key,
      required this.isLoading,
      required this.err,
      required this.userModel,
      required this.signInWithEmailAndPassword});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _userLogin() async {
    if (!_form.currentState!.validate()) return;
    widget.signInWithEmailAndPassword(
        _emailController.text.trim(), _passwordController.text.trim());
    //await Future.delayed(const Duration(seconds: 2));
    if (scaffoldMessengerKey.currentState != null) {
      scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
    }
    if (widget.userModel.uid != null) {
      // Navigate to the Home screen upon success
      Navigator.pushNamed(context, RoutesName.homePageScreen);
      scaffoldMessengerKey.currentState!
        ..hideCurrentSnackBar
        ..showSnackBar(
          const SnackBar(
            content: Text('Login Successfully'),
            backgroundColor: Colors.lightGreen,
          ),
        );
    } else {
      scaffoldMessengerKey.currentState!
        ..hideCurrentSnackBar
        ..showSnackBar(
          SnackBar(
            content: Text(widget.err),
            backgroundColor: Colors.redAccent,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Login',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Email is Empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.grey),
                        ),
                        inputFormatters: [NoSpacesFormatter()],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: _passwordController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Password is Empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.grey),
                        ),
                        inputFormatters: [NoSpacesFormatter()],
                      ),
                      const SizedBox(height: 20),
                      widget.isLoading == null || widget.isLoading == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : CustomButton(
                              onPressed: _userLogin,
                              text: 'Login',
                            ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, RoutesName.registerScreen);
                              },
                              child: const Text(
                                'Register Here',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
