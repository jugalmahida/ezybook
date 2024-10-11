import 'dart:async';
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

  late UserModel user;

  Timer? emailTimer;

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
                  get20height(),
                  getTextFiled(
                    hintText: "Enter Full Name",
                    controller: _fullName,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      value = value?.trim() ?? '';
                      if (value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  get20height(),
                  getTextFiled(
                    hintText: "Enter Mobile Number",
                    controller: _mobileNumber,
                    keyboardType: TextInputType.phone,
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
                  get20height(),
                  getMainButton(
                      onPressed: () async {
                        // Unfocus the text fields
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formKey.currentState?.validate() ?? false) {
                          final name = _fullName.text.trim();
                          final number = _mobileNumber.text.trim();
                          final email = _email.text.trim();
                          final password = _password.text.trim();

                          user = UserModel(
                              name: name, number: number, email: email);
                          registerUser(password);
                        }
                      },
                      name: "Sign Up"),
                  get20height(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      getLinkButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(
                                context, '/signin_screen');
                          },
                          name: "Sign In"),
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

  void registerUser(String password) async {
    // Show loading dialog
    showLoadingDialog(context);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email!, password: password);

      final cUser = FirebaseAuth.instance.currentUser!;

      await cUser.sendEmailVerification();
      print("Email verification send");
      if (mounted) {
        String title = "Check Your Email";
        String msg =
            "We have send email verifition instruction to your ${user.email}";
        checkEmailDialog(context, title, msg);
      }

      emailTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        await FirebaseAuth.instance.currentUser?.reload();
        final cUser = FirebaseAuth.instance.currentUser;
        if (cUser?.emailVerified ?? false) {
          emailTimer!.cancel();
          DatabaseReference ref = FirebaseDatabase.instance.ref("Users");
          // Generate a unique user ID
          DatabaseReference userRef = ref.push();
          await userRef.set(user.toJson());
          // Show success dialog
          if (mounted) {
            dismissLoadingDialog(); // Dismiss the loading dialog
          }
          SharedPreferences preferences = await SharedPreferences.getInstance();
          setState(() {
            // print(userRef.key.toString());
            user.uId = userRef.key.toString();
          });
          String userJson = jsonEncode(user.toJson());
          await preferences.setString("user", userJson);
          await preferences.setBool("isLogin", true);
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home_screen');
        }
      });
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss the loading dialog

        switch (e.code) {
          case "email-already-in-use":
            showErrorDialog(
                context, "Email already in use", "Try with a different email");
            break;

          case "invalid-email":
            showErrorDialog(context, "Invalid Email", e.message!);
            break;

          default:
            showErrorDialog(context, "Internal Error",
                "An unexpected error occurred. Please try again later.");
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss the loading dialog
        showErrorDialog(context, "Error",
            "An unexpected error occurred. Please try again later.");
      }
    }
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
