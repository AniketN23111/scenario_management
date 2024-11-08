import 'package:flutter/material.dart';

import '../../TypeDef/type_def.dart';
import '../../route_names/route_names.dart';

class LoginScreen extends StatefulWidget {
  final bool? isLoading;
  final SignInWithEmailAndPasswordTypeDef signInWithEmailAndPassword;

  const LoginScreen(
      {super.key,
      required this.isLoading,
      required this.signInWithEmailAndPassword});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
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
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            widget.isLoading == null || widget.isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: () {
                      widget.signInWithEmailAndPassword(
                          _emailController.text, _passwordController.text);
                      if(widget.isLoading==false){
                        Navigator.pushNamed(context, RoutesName.homePageScreen);
                      }
                    },
                    child: const Text('Login')),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.registerScreen);
                },
                child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}
