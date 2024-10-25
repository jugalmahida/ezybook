import 'dart:convert';
import 'package:ezybook/Screens/summaryscreen.dart';
import 'package:ezybook/models/booking.dart';
import 'package:ezybook/models/shop.dart';
import 'package:ezybook/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // Import this for StreamSubscription

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  List<Booking>? requestedBooking = [];
  Shop? shop;
  StreamSubscription<DatabaseEvent>? _subscription; // Declare the subscription

  getBookingData() async {
    UserModel? user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("user");

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);

      setState(() {
        user = UserModel.fromJson(userMap);
      });
    }

    Query query = FirebaseDatabase.instance
        .ref("Booking")
        .orderByChild("userId")
        .equalTo(user?.uId);

    // Store the subscription
    _subscription = query.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
      final data = snapshot.value as Map<Object?, Object?>?;
      if (data != null && data.isNotEmpty) {
        List<Booking> newBookings = [];
        data.forEach((key, value) {
          if (value is Map<Object?, Object?>) {
            Booking booking =
                Booking.fromJson(value.cast<String, dynamic>(), key.toString());
            newBookings.add(booking);
          }
        });
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            requestedBooking = newBookings;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getBookingData();
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Cancel the subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track your requests"),
      ),
      body: requestedBooking?.isNotEmpty == true // Simplified check
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: requestedBooking?.length,
                itemBuilder: (context, index) {
                  Booking? booking = requestedBooking?[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.store),
                      title: Text("${booking?.shopName}"),
                      subtitle: Text(
                        "Booking Status - ${booking?.status}",
                        style: const TextStyle(fontSize: 15),
                      ),
                      trailing: Text(
                        "Date - ${booking?.date}",
                        style: const TextStyle(fontSize: 15),
                      ),
                      onTap: () {
                        SummaryScreen.booking = booking;
                        Navigator.pushNamed(
                          context,
                          "/summary_screen_screen",
                        );
                      },
                    ),
                  );
                },
              ),
            )
          : const Center(
              child: Text(
                "No booking found",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
    );
  }
}
