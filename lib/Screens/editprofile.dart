import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // TextEditingControllers to manage the text input fields
  final TextEditingController _fullNameController =
      TextEditingController(text: "Raj Mehta");
  final TextEditingController _locationController =
      TextEditingController(text: "NY, US");
  final TextEditingController _mobileNumberController =
      TextEditingController(text: "1236547890");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
            onPressed: () {
              // Handle save action here
            },
            child: const Text(
              "Done",
              style: TextStyle(color: Colors.orange, fontSize: 16),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/ProfileIcon.png'),
            ),
            TextButton(
              onPressed: () {
                // Handle change profile picture action here
              },
              child: const Text(
                "Change Profile Picture",
                style: TextStyle(color: Colors.orange),
              ),
            ),
            const SizedBox(height: 20),
            // First Name
            _buildTextField(
              controller: _fullNameController,
              label: "First Name",
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 20),
            // Location
            _buildTextField(
              controller: _locationController,
              label: "Location",
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            // Mobile Number
            _buildTextField(
              controller: _mobileNumberController,
              label: "Mobile Number",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method to build each TextField with appropriate keyboardType
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
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
          suffixIcon: const Icon(Icons.check, color: Colors.orange),
        ),
      ),
    );
  }
}
