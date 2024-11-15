import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scenario_management/route_names/route_names.dart';
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

  List<Map<String, String>> designations = [];
  Map<String, String>? selectedDesignation;
  bool _isSubmitting = false; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchDesignations();
  }

  void _fetchDesignations() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('role').get();
      setState(() {
        designations = snapshot.docs.map((doc) {
          return {
            'id': doc['id'] as String,
            'name': doc['name'] as String,
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching roles: $e");
    }
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    // Call the registration function
     widget.registerWithEmailAndDesignationTypeDef(
      _emailController.text,
      _passwordController.text,
      selectedDesignation?['id'] ?? '',
      _nameController.text,
    );

    // Simulate Redux state update time
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isSubmitting = false;
    });

    // Navigate to the login screen upon success
    Navigator.pushNamed(context, RoutesName.loginScreen);
  }

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
              designations.isEmpty
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<Map<String, String>>(
                value: selectedDesignation,
                items: designations.map((designation) {
                  return DropdownMenuItem<Map<String, String>>(
                    value: designation,
                    child: Text(designation['name']!),
                  );
                }).toList(),
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
              _isSubmitting
                  ? const CircularProgressIndicator() // Loading indicator during submission
                  : ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
