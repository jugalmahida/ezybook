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
  List<Booking>? filteredBookings = [];
  Shop? shop;
  StreamSubscription<DatabaseEvent>? _subscription; // Declare the subscription
  Query? bookingQuery;
  TextEditingController searchController =
      TextEditingController(); // Controller for the search field

  @override
  void initState() {
    super.initState();
    getBookingData();
    searchController.addListener(() {
      filterBookings();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Cancel the subscription
    searchController.dispose(); // Dispose of the search controller
    super.dispose();
  }

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
            filteredBookings =
                newBookings; // Initially set filtered bookings to all bookings
            bookingQuery = query;
          });
        }
      }
    });
  }

  void filterBookings() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredBookings = requestedBooking; // No filter if search is empty
      });
    } else {
      setState(() {
        filteredBookings = requestedBooking?.where((booking) {
          return booking.shopName.toLowerCase().contains(query) ||
              booking.status.toLowerCase().contains(query) ||
              booking.date.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  void _deleteBookingById(String bookingId) async {
    await bookingQuery?.ref // Reference the root of the database
        .child(bookingId) // The specific booking by ID
        .remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track your requests"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search by Shop Name, Status, or Date",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          filteredBookings?.isNotEmpty == true
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: filteredBookings?.length,
                      itemBuilder: (context, index) {
                        Booking? booking = filteredBookings?[index];
                        return GestureDetector(
                          onLongPress: () async {
                            bool shouldDelete = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Delete Booking"),
                                      content: const Text(
                                          "Are you sure you want to delete this booking?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(false); // Cancel
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(true); // Confirm delete
                                          },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                ) ??
                                false;
                            if (shouldDelete) {
                              _deleteBookingById(booking!.bookingId);
                              if (mounted) {
                                Navigator.pushReplacementNamed(
                                    context, '/home_screen');
                              }
                            }
                          },
                          child: Card(
                            child: ListTile(
                              leading: const Icon(Icons.store),
                              title: Text("${booking?.shopName}"),
                              subtitle: booking?.shopCategory == "Salon"
                                  ? Text(
                                      "Status - ${booking?.status}\n₹${booking?.totalFee}",
                                      style: const TextStyle(fontSize: 15),
                                    )
                                  : Text(
                                      "Status - ${booking?.status}",
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
                                  arguments: {
                                    "bookingID": booking?.bookingId,
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
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
        ],
      ),
    );
  }
}
