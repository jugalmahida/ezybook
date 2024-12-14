import 'package:ezybook/models/booking.dart';
import 'package:ezybook/widgets/button.dart';
import 'package:ezybook/widgets/sizedbox.dart';
import 'package:ezybook/widgets/snakbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});
  static Booking? booking; // This will hold the booking data globally

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  String isSeatorTable = "";
  String bookID = "";
  late DatabaseReference bookingRef;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch arguments after the widget is fully initialized
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      final String bookingID = arguments['bookingID'];
      bookID = bookingID; // Store the booking ID for use

      // Query Firebase based on the booking ID
      _fetchBookingData(bookingID);
    }

    if (SummaryScreen.booking?.shopCategory == "Salon") {
      isSeatorTable = "Seat";
    } else {
      isSeatorTable = "Table";
    }
  }

  // Function to fetch booking data from Firebase
  Future<void> _fetchBookingData(String bookingID) async {
    bookingRef = FirebaseDatabase.instance.ref("Booking").child(bookingID);

    // Listen for changes in the booking data
    bookingRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<Object?, Object?>?;

      if (data != null && mounted) {
        // print(data);
        // Check if widget is still mounted
        // Map the data to your Booking model
        setState(() {
          SummaryScreen.booking =
              Booking.fromJson(data.cast<String, dynamic>(), bookingID);
        });
      }
    });
  }

  @override
  void dispose() {
    // Ensure that you cancel the Firebase listener when the widget is disposed
    bookingRef.onDisconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SummaryScreen.booking == null
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    SummaryScreen.booking?.status == "Accepted"
                        ? Column(
                            children: [
                              Image.asset(
                                height: 200,
                                'assets/images/bookingdone.gif',
                                fit: BoxFit.cover,
                              ),
                              get10height(),
                              const Text(
                                "Congratulations !!!",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                        : const SizedBox(),

                    SummaryScreen.booking?.status == "Pending"
                        ? Column(
                            children: [
                              get10height(),
                              const Text(
                                "Request Send to Owner",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : const SizedBox(),

                    get10height(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.store),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${SummaryScreen.booking?.shopName}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    get10height(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          SummaryScreen.booking?.date ?? "N/A",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    get10height(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_time_rounded),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          SummaryScreen.booking?.reachOutTime ?? "N/A",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    get10height(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "${SummaryScreen.booking?.shopAddress}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    // Displaying shop services
                    SummaryScreen.booking?.shopCategory == "Salon"
                        ? Column(
                            children: [
                              get10height(),
                              const Text(
                                "Selected Services",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              get10height(),
                              ListView(
                                shrinkWrap: true,
                                children: SummaryScreen.booking!.shopServices!
                                    .map((shopService) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          shopService.serviceName ?? 'No Name',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          shopService.serviceCharge ??
                                              'No Charge',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    get10height(),
                    Text(
                      "Status - ${SummaryScreen.booking?.status}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    SummaryScreen.booking?.status == "Cancel"
                        ? Column(
                            children: [
                              get10height(),
                              Text(
                                "Cancel Reason - ${SummaryScreen.booking?.cancelReason}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        : const SizedBox(),

                    SummaryScreen.booking?.status == "Accepted"
                        ? Column(
                            children: [
                              get10height(),
                              Text(
                                "Your $isSeatorTable Number - ${SummaryScreen.booking?.numberOfSeatorTable}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        : const SizedBox(),

                    SummaryScreen.booking?.shopCategory == "Salon"
                        ? Column(
                            children: [
                              // Displaying the total amount
                              get10height(),
                              Text(
                                "Total Amount: ₹${SummaryScreen.booking!.totalFee ?? "N/A"}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                        : const SizedBox(),
                    get10height(),
                    TextButton.icon(
                      onPressed: () async {
                        TimeOfDay selectDateTime =
                            TimeOfDay.now(); // Default to current time

                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: selectDateTime, // Set the initial time
                        );

                        // If the user selects a time (not null), update the selected time
                        if (picked != null) {
                          setState(() {
                            selectDateTime = picked;
                            // print(picked.format(context));
                            bookingRef.update(
                                {"reachOutTime": picked.format(context)});
                          });
                        }
                      },
                      icon: const Icon(Icons.access_time_rounded),
                      label: const Text(
                        "Change ReachOut Time",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        Uri phoneUri = Uri.parse(
                            'tel:${SummaryScreen.booking!.shopNumber}'); // Phone number you want to dial
                        _launch(phoneUri, context);
                      },
                      icon: const Icon(Icons.call),
                      label: Text(
                        "Call the ${SummaryScreen.booking!.shopName}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    get10height(),
                    getMainButton(
                        onPressed: () {
                          final reasons = [
                            "Today, I am Busy!!!",
                            "Other (please specify)",
                          ];

                          TextEditingController customController =
                              TextEditingController();

                          showDialog(
                            context: context,
                            builder: (context) {
                              String?
                                  selectedReason; // Move this inside the builder

                              return AlertDialog(
                                title: const Text("Select a cancel reason"),
                                content: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Radio buttons for selecting a reason
                                        for (var reason in reasons)
                                          ListTile(
                                            title: Text(reason),
                                            leading: Radio<String>(
                                              value: reason,
                                              groupValue: selectedReason,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedReason = value;
                                                  if (value !=
                                                      "Other (please specify)") {
                                                    customController
                                                        .clear(); // Clear custom message if a reason is selected
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        // Text field for custom message
                                        if (selectedReason ==
                                            "Other (please specify)")
                                          TextField(
                                            controller: customController,
                                            decoration: const InputDecoration(
                                              labelText: 'Please specify',
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      selectedReason = selectedReason?.trim();
                                      if (selectedReason != null) {
                                        // Handle the selected reason and optional custom message
                                        if (selectedReason ==
                                            "Other (please specify)") {
                                          if (customController.text
                                              .trim()
                                              .isEmpty) {
                                            getSnakbar("Please give a reason",
                                                context);
                                            return;
                                          }
                                        }

                                        var upData = {
                                          "status": "Cancel",
                                          "cancelReason": selectedReason ==
                                                  "Other (please specify)"
                                              ? customController.text.trim()
                                              : selectedReason,
                                          "numberOfSeatorTable": 0,
                                        };
                                        // Update booking reference
                                        bookingRef.update(upData);
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      } else {
                                        // Show a Snackbar if no reason is selected
                                        getSnakbar(
                                            "Please select a reason", context);
                                      }
                                    },
                                    child: const Text("Submit"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        name: "Cancel Request"),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _launch(Uri url, BuildContext context) async {
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : getSnakbar('Could not launch', context);
  }
}
