import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/auth/auth_new/my_register.dart';

import '../../constants.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  String username = '', email = '';
  final unameController = TextEditingController();
  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> sendFormData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer(
      builder: (BuildContext context, value, Widget? child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * .3,
                      child: const Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: unameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppConstants.mainGreen),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  label: const Text('Enter Username'),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length <= 1 ||
                                      value.trim().length >= 50 ||
                                      int.tryParse(value) is! int) {
                                    return 'Please enter a number';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  username = value!;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppConstants.mainGreen),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  label: const Text('Enter Email'),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length <= 1 ||
                                      value.trim().length >= 50) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  email = value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await sendFormData();
                                    int stCode = 200;
                                    if (stCode == 200 || stCode == 201) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * .3,
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Don't have an account?  ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              TextSpan(
                                text: 'Sign Up.',
                                style: const TextStyle(
                                  color: AppConstants.mainGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
