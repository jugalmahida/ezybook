// ignore: file_names
import 'dart:convert';

import 'package:ezybook/models/user.dart';
import 'package:ezybook/widgets/sizedbox.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserModel? user;
  UserModel? userRealTime;

  @override
  void initState() {
    super.initState();
    getUserData(); // fetch user data
  }

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("user");

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        user = UserModel.fromJson(userMap);
        getUserDataFromFirebase();
      });
    }
  }

  getUserDataFromFirebase() {
    Query query = FirebaseDatabase.instance.ref("Users");
    query.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
      final data = snapshot.value as Map<Object?, Object?>?;

      if (data != null) {
        data.forEach((key, value) {
          if (key == user?.uId) {
            if (mounted) {
              // Check if the widget is still mounted
              setState(() {
                userRealTime =
                    UserModel.fromJson(Map<String, dynamic>.from(value as Map));
              });
            }
          }
        });
      }
    }, onError: (error) {
      print('Error occurred: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40, // Adjust the size as needed
                backgroundColor: Colors
                    .blue, // Set a background color or use a color from the user's profile
                child: Text(
                  user?.name?.isNotEmpty == true
                      ? user!.name![0].toUpperCase()
                      : '?', // First letter of the name
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              get10height(),
              Text(
                userRealTime?.name ?? "N/A",
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                userRealTime?.email ?? "N/A",
                style: const TextStyle(color: Colors.grey, fontSize: 18),
              ),
              get10height(),
              // Insert the list widget here
              const Expanded(child: ProfileMenuList()),
            ],
          ),
        ),
      ),
    );
  }

  Card getCard({required String name, required String value}) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProfileMenuItem(
          icon: Icons.person_outline,
          text: "Edit Profile",
          onTap: () {
            Navigator.pushNamed(context, "/edit_profile_screen");
          },
        ),
        ProfileMenuItem(
          icon: Icons.track_changes,
          text: "Track your request",
          onTap: () {
            Navigator.pushNamed(context, "/requests_screen_screen");
          },
        ),
        // ProfileMenuItem(
        //   icon: Icons.history,
        //   text: "Recently Viewed Shops",
        //   onTap: () {
        //     // Navigator.pushNamed(context, "/recently_viewed_shops_screen");
        //   },
        // ),
        ProfileMenuItem(
          icon: Icons.info_outline,
          text: "Version",
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("App Version"),
                content: const Text("Version 1.0.0"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          },
        ),
        ProfileMenuItem(
          icon: Icons.exit_to_app,
          text: "Sign out",
          onTap: () {
            // Handle sign-out logic here, such as clearing user session or data
            signOut();
            // Navigate to sign-in screen and remove all previous routes
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/signin_screen",
              (Route<dynamic> route) => false, // Remove all routes
            );
          },
        ),
      ],
    );
  }

  void signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogin", false);
    prefs.setString("user", "");
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
    );
  }
}
