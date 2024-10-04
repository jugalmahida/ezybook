import 'dart:convert';

import 'package:ezybook/models/user.dart';
import 'package:ezybook/widgets/button.dart';
import 'package:ezybook/widgets/dialog.dart';
import 'package:ezybook/widgets/sizedbox.dart';
import 'package:ezybook/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign in now',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  get15height(),
                  const Text(
                    "Please sign in to continue our app",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  get20height(),
                  getTextFiled(
                    hintText: "Enter Email",
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
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
                  get20height(),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    obscureText: passwordVisible,
                    controller: _password,
                    keyboardType: TextInputType.visiblePassword,
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
                  getLinkButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forget_password_screen');
                      },
                      name: "Forget Password?"),
                  get10height(),
                  getMainButton(
                      onPressed: () async {
                        // Unfocus the text fields
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formKey.currentState?.validate() ?? false) {
                          showLoadingDialog(context);
                          bool errorOccurred = false;

                          final email = _email.text.trim();
                          final password = _password.text.trim();
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email, password: password);
                            // Navigator.popAndPushNamed(context, '/home_screen');
                            UserModel? user = await _getUserData(email);
                            print(user);
                            if (user != null) {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              String shopJson = jsonEncode(user.toJson());
                              await preferences.setString("user", shopJson);
                              await preferences.setBool("isLogin", true);
                              if (!mounted) return;
                              await Navigator.pushReplacementNamed(
                                  context, '/home_screen');
                            }
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            errorOccurred = true;

                            if (mounted) {
                              Navigator.of(context)
                                  .pop(); // Dismiss the loading dialog

                              switch (e.code) {
                                case "wrong-password":
                                  showErrorDialog(context, "Wrong Password",
                                      "The password you provided is incorrect. Try resetting your password.");
                                  break;
                                case "invalid-email":
                                  showErrorDialog(context, "Invalid Email",
                                      "The email address you provided is invalid.");
                                  break;
                                case "user-disabled":
                                  showErrorDialog(context, "Account Disabled",
                                      "Your account has been disabled. Contact support for assistance.");
                                  break;
                                case "user-not-found":
                                  showErrorDialog(context, "User Not Found",
                                      "The email address you provided is not registered. Please sign up.");
                                  break;
                                case "network-request-failed":
                                  showErrorDialog(
                                      context,
                                      "No Internet Connection",
                                      "Please check your internet connection.");
                                  break;
                                case "invalid-credential":
                                  showErrorDialog(context, "Invalid Credential",
                                      "Invalid email or password.");
                                  break;
                                case "too-many-requests":
                                  showErrorDialog(
                                      context,
                                      "Too many login attempts",
                                      "You can try again later.");
                                  break;
                                default:
                                  showErrorDialog(context, "Error",
                                      "An unexpected error occurred from the database. Please try again later.");
                              }
                            }
                          } catch (e) {
                            print(e);
                            errorOccurred = true;

                            if (mounted) {
                              Navigator.of(context)
                                  .pop(); // Dismiss the loading dialog
                              showErrorDialog(context, "Error",
                                  "An unexpected error occurred. Please try again later.");
                            }
                          } finally {
                            if (mounted && !errorOccurred) {
                              Navigator.of(context)
                                  .pop(); // Dismiss the loading dialog only if no error occurred
                            }
                          }
                        }
                      },
                      name: "Sign In"),
                  get20height(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      getLinkButton(
                          onPressed: () => Navigator.popAndPushNamed(
                              context, '/signup_screen'),
                          name: "Sign Up"),
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

  Future<UserModel?> _getUserData(String email) async {
    Query userRef = FirebaseDatabase.instance
        .ref('Users')
        .orderByChild("email")
        .equalTo(email);
    try {
      final snapshot = await userRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<Object?, Object?>?;
        if (data != null && data.isNotEmpty) {
          // Get the first user's data
          final userId = data.keys.first;
          final userInfo = data[userId] as Map<Object?, Object?>;
          final shop = UserModel.fromJson(userInfo.cast<String, dynamic>());
          return shop; // Return the Shop instance
        }
      } else {
        if (mounted) {
          showErrorDialog(context, "Internal Error", "Contact the developer");
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }
}
