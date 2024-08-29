import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullName;
  late final TextEditingController _mobileNumber;
  late final TextEditingController _email;
  late final TextEditingController _password;

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _fullName = TextEditingController();
    _mobileNumber = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xfffefffe),
        child: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign up now',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Please fill the details and create account",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _fullName,
                    decoration: InputDecoration(
                      hintText: "Enter Full Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    validator: (value) {
                      value = value?.trim() ?? '';
                      if (value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.phone,
                    controller: _mobileNumber,
                    decoration: InputDecoration(
                      hintText: "Enter Mobile Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    validator: (value) {
                      value = value?.trim() ?? '';
                      if (value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (value.length != 10) {
                        return 'Mobile number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: "Enter Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    validator: (value) {
                      value = value?.trim() ?? '';
                      if (value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    obscureText: !passwordVisible,
                    controller: _password,
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      value = value?.trim() ?? '';
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF24BAEC),
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                final name = _fullName.text.trim();
                                final number = _mobileNumber.text.trim();
                                final email = _email.text.trim();
                                final password = _password.text.trim();

                                print(
                                    "Fullname - $name | number - $number | email - $email | password - $password");
                                // Navigator.pushNamed(context, '/optverification_screen');
                              }
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                        "Already have an account?",
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(context, '/signin_screen');
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(color: Colors.orange, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _fullName.dispose();
    _mobileNumber.dispose();
    _email.dispose();
    _password.dispose();
  }
}
