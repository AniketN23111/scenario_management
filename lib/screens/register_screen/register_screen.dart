import 'package:flutter/material.dart';
import 'package:scenario_management/firebase/firestore_services.dart';
import 'package:scenario_management/route_names/route_names.dart';
import '../../TypeDef/type_def.dart';

/// Register Screen
class RegisterScreen extends StatefulWidget {
  final bool isLoading;
  final RegisterWithEmailAndDesignationTypeDef
      registerWithEmailAndDesignationTypeDef;
  final String err;

  const RegisterScreen({
    super.key,
    required this.isLoading,
    required this.registerWithEmailAndDesignationTypeDef,
    required this.err,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
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
      List<Map<String, String>> fetchedDesignations = await FirestoreService().fetchDesignations();
      setState(() {
        designations = fetchedDesignations;
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
    if(widget.err.isEmpty)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Register Successfully'),backgroundColor: Colors.lightGreen,),
        );
        await Future.delayed(const Duration(seconds: 1));
        // Navigate to the login screen upon success
        Navigator.pushNamed(context, RoutesName.loginScreen);
      }
   else{
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(widget.err),backgroundColor: Colors.redAccent,),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Register',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Name Field
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
                        prefixIcon: const Icon(Icons.format_color_text_rounded,
                            color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email Field
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
                        prefixIcon: const Icon(Icons.email, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Field
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
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Confirm Password Field
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "Confirm Password is Empty";
                        } else if (text != _passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(15),
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Dropdown for Designation
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
                              prefixIcon: const Icon(Icons.accessibility_sharp,
                                  color: Colors.grey),
                            ),
                            validator: (value) => value == null
                                ? 'Please select a designation'
                                : null,
                          ),
                    const SizedBox(height: 20),
                    // Submit Button
                    _isSubmitting
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.greenAccent, // Green Accent Button
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Submit'),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
