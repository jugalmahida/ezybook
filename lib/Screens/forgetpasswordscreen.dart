import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late final TextEditingController _forgetEmail;
  @override
  void initState() {
    super.initState();
    _forgetEmail = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _forgetEmail.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
            child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100.0,
              ),
              const Text(
                "Forget Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Enter your email account to reset your password",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextField(
                autocorrect: false,
                enableSuggestions: false,
                controller: _forgetEmail,
                decoration: InputDecoration(
                  hintText: "Enter Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF24BAEC)),
                        onPressed: () {
                          // Your onPressed logic here
                          _checkEmailDialog(context);
                        },
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

  void _checkEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Image.asset(
            height: 60,
            'assets/images/CheckEmail.png',
          ),
          title: const Text(
            textAlign: TextAlign.center,
            'Check your email',
          ),
          content: const Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: Text(
              textAlign: TextAlign.center,
              'We have send password recovery instrucation to your email',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
