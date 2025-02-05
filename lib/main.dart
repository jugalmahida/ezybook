import 'package:ezybook/Screens/UserProfile.dart';
import 'package:ezybook/Screens/editprofile.dart';
import 'package:ezybook/Screens/requestsscreen.dart';
import 'package:ezybook/Screens/searchscreen.dart';
import 'package:ezybook/Screens/shopdetails.dart';
import 'package:ezybook/Screens/summaryscreen.dart';
import 'package:flutter/material.dart';

import 'Screens/forgetpasswordscreen.dart';
import 'Screens/homescreen.dart';
import 'Screens/optverificarion.dart';
import 'Screens/signinscreen.dart';
import 'Screens/signupscreen.dart';
import 'Screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ezy Book',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // You can further customize the light theme here
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // You can further customize the dark theme here
      ),
      themeMode:
          ThemeMode.system, // This will follow the system theme (light or dark)

      // Define the initial route
      initialRoute: '/splashscreen',

      routes: {
        '/splashscreen': (context) => const SplashScreen(),
        '/home_screen': (context) => const HomeScreen(),
        '/signup_screen': (context) => const SignupScreen(),
        '/signin_screen': (context) => const SigninScreen(),
        '/optverification_screen': (context) => const OTPVerification(),
        '/forget_password_screen': (context) => const ForgetPassword(),
        '/search_screen': (context) => const SearchScreen(),
        '/shop_details_screen': (context) => const ShopDetails(),
        '/user_profile_screen': (context) => const UserProfile(),
        '/edit_profile_screen': (context) => const EditProfile(),
        '/summary_screen_screen': (context) => const SummaryScreen(),
        '/requests_screen_screen': (context) => const RequestsScreen(),
      },
    );
  }
}
