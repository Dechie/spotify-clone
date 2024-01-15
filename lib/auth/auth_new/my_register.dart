import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/auth/auth_new/my_login.dart';

import '../../constants.dart';
import '../../models/user.dart';
import '../../providers/the_auth.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({
    super.key,
  });
  String username = '', email = '';
  String password = '', passwordConfirm = '';

  final unameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController1 = TextEditingController();
  final passwordController2 = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> sendFormData(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      User user = User(
        name: username,
        email: email,
        password: passwordConfirm,
      );

      //Navigator.pop(context, user);
      Provider.of<Auth>(context, listen: false).register(user);
      Navigator.pop(context);
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
                      height: size.height * .27,
                      child: const Center(
                        child: Text(
                          'Sign Up',
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
                              SizedBox(
                                height: 65,
                                width: double.infinity,
                                child: TextFormField(
                                  controller: unameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppConstants.mainGreen),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    label: const Text('Enter Username'),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.trim().length <= 1 ||
                                        value.trim().length >= 50) {
                                      return 'Please enter a username';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    username = value!;
                                  },
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: double.infinity,
                                height: 65,
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppConstants.mainGreen),
                                      borderRadius: BorderRadius.circular(14),
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
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: double.infinity,
                                height: 65,
                                child: TextFormField(
                                  controller: passwordController1,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppConstants.mainGreen),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    label: const Text('Enter Password'),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.trim().length <= 1 ||
                                        value.trim().length >= 50) {
                                      return 'Please enter a valid password';
                                    }
                                    if (value.isNotEmpty &&
                                        value != passwordController2.text) {
                                      return 'passwords don\'t match';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    password = value!;
                                  },
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: double.infinity,
                                height: 65,
                                child: TextFormField(
                                  controller: passwordController2,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppConstants.mainGreen),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    label: const Text('Confirm Password'),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.trim().length <= 1 ||
                                        value.trim().length >= 50) {
                                      return 'Please enter a valid Password';
                                    }
                                    if (value.isNotEmpty &&
                                        value != passwordController1.text) {
                                      return 'passwords don\'t match';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    passwordConfirm = value!;
                                  },
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      sendFormData(context);
                                    },
                                    child: const Text('Submit'),
                                  ),
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
                                text: "Already have an account?  ",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                  text: 'Sign In.',
                                  style: const TextStyle(
                                    color: AppConstants.mainGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                                    }),
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
