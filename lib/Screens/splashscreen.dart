import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? _isLogin;
  Future<void> getValueofPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLogin = prefs.getBool("isLogin") ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    await getValueofPref(); // Wait for the value to be fetched
    Future.delayed(const Duration(seconds: 3), () {
      if (_isLogin!) {
        // Check if _shop is not null
        Navigator.pushReplacementNamed(context, '/home_screen');
      } else {
        Navigator.pushReplacementNamed(context, '/signin_screen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF24BAEC),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
