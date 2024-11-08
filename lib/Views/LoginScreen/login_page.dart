import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../RouteNames/route_names.dart';
import '../../TypeDef/type_def.dart';


class LoginScreen extends StatefulWidget {
  final bool? isLoading;
  final SignInWithEmailAndPasswordTypeDef signInWithEmailAndPassword;
  const LoginScreen({super.key, required this.isLoading,  required this.signInWithEmailAndPassword});

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

  void userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushNamed(context, RoutesName.homePageScreen);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid Login Credentials'),
          backgroundColor: Colors.redAccent,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${e.code}'),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
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
            ElevatedButton(onPressed: userLogin, child: const Text('Login')),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  //Navigator.pushNamed(context, RoutesName.register);
                },
                child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}
