import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xfffefffe),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign in now',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Please sign in to continue our app",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
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
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                    autocorrect: false,
                    enableSuggestions: false,
                    obscureText: passwordVisible,
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
                          setState(
                            () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                      alignLabelWithHint: false,
                    ),
                    keyboardType: TextInputType.visiblePassword),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forget_password_screen');
                      },
                      child: const Text(
                        'Forget Password?',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: FilledButton(
                            style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF24BAEC)),
                            onPressed: () => {
                                  Navigator.popAndPushNamed(
                                      context, '/home_screen')
                                },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(fontSize: 17),
                            )),
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
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/signup_screen');
                      },
                      child: const Text(
                        "Sign Up",
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }
}
