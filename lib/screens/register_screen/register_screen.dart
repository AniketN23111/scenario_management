import 'package:flutter/material.dart';
import '../../TypeDef/type_def.dart';

/// Register Screen
class RegisterScreen extends StatefulWidget {
  final bool isLoading;
  final RegisterWithEmailAndDesignationTypeDef
      registerWithEmailAndDesignationTypeDef;

  const RegisterScreen({
    super.key,
    required this.isLoading,
    required this.registerWithEmailAndDesignationTypeDef,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  List<String> designations = ['Junior Tester', 'Tester Lead'];
  String? selectedDesignation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Form(
        key: _form,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: _nameController,
                validator: (text) =>
                    text == null || text.isEmpty ? "Name is Empty" : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(15),
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (text) =>
                    text == null || text.isEmpty ? "Email is Empty" : null,
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
                obscureText: true,
                validator: (text) =>
                    text == null || text.isEmpty ? "Password is Empty" : null,
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
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedDesignation,
                items: designations
                    .map((designation) => DropdownMenuItem(
                          value: designation,
                          child: Text(designation),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDesignation = value;
                  });
                },
                hint: const Text('Select Designation'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value == null ? 'Please select a designation' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.registerWithEmailAndDesignationTypeDef(
                      _emailController.text,
                      _passwordController.text,
                      selectedDesignation.toString(),
                      _nameController.text);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
