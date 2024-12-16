import 'dart:convert';

import 'package:ezybook/models/user.dart';
import 'package:ezybook/widgets/snakbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserModel? user;
  UserModel? userRealTime;

  // TextEditingControllers to manage the text input fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  // Global key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getUserData();
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

      // Ensure that the data is a Map with a proper key-value structure
      if (data != null) {
        data.forEach((key, value) {
          if (key == user?.uId) {
            // Ensure the widget is still mounted before calling setState
            if (mounted) {
              setState(() {
                // Cast the value to Map<String, dynamic> and create UserModel
                userRealTime =
                    UserModel.fromJson(Map<String, dynamic>.from(value as Map));

                _fullNameController.text = userRealTime?.name ?? "";
                _emailController.text = userRealTime?.email ?? "";
                _mobileNumberController.text = userRealTime?.number ?? "";
              });
            }
          }
        });
      }
    }, onError: (error) {
      print('Error occurred: $error');
    });
  }

  // Validation logic
  String? _validateFullName(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? _validateMobileNumber(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    // Check if the mobile number has the correct format (e.g., 10 digits)
    if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
            onPressed: () async {
              // Unfocus the text fields
              FocusManager.instance.primaryFocus?.unfocus();
              // Validate the form
              if (_formKey.currentState?.validate() ?? false) {
                // print('Full Name: ${_fullNameController.text.trim()}');
                // print('Mobile Number: ${_mobileNumberController.text.trim()}');
                await updateUserData(_fullNameController.text.trim(),
                    _mobileNumberController.text.trim());
                if (!mounted) return;
                getSnakbar("Profile Updated!", context);
              }
            },
            child: const Text(
              "Done",
              style: TextStyle(color: Colors.orange, fontSize: 16),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // Assign the form key
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Full Name
              _buildTextField(
                controller: _fullNameController,
                label: "Full Name",
                keyboardType: TextInputType.name,
                validator: _validateFullName,
              ),
              const SizedBox(height: 20),
              // Location (email is non-editable)
              _buildTextField(
                controller: _emailController,
                label: "Email",
                keyboardType: TextInputType.emailAddress,
                isEnable: false, // Email is read-only
              ),
              const SizedBox(height: 20),
              // Mobile Number
              _buildTextField(
                controller: _mobileNumberController,
                label: "Mobile Number",
                keyboardType: TextInputType.phone,
                validator: _validateMobileNumber,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUserData(String name, String number) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("Users").child(user?.uId ?? "");

    try {
      await reference.update({"name": name, "number": number});
    } catch (e) {
      print(e);
    }
  }

  // Helper method to build each TextField with appropriate keyboardType
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    bool isEnable = true,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        enabled: isEnable,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.orange),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.orange),
          ),
        ),
        validator: validator, // Use validator passed in
      ),
    );
  }
}
