import 'dart:convert';

import 'package:ezybook/models/booking.dart';
import 'package:ezybook/models/shop.dart';
import 'package:ezybook/models/shopservice.dart';
import 'package:ezybook/models/user.dart';
import 'package:ezybook/widgets/button.dart';
import 'package:ezybook/widgets/dialog.dart';
import 'package:ezybook/widgets/sizedbox.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetails extends StatefulWidget {
  const ShopDetails({super.key});

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  bool isExpanded = false;
  bool isOverflowing = false;
  List<ShopService> selectedServices = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkTextOverflow());
  }

  void checkTextOverflow() {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final Shop tempShop = arguments?['shop'] ?? 'Not available';
    final aboutShop = tempShop.shopAddress;
    final TextSpan textSpan = TextSpan(
      text: aboutShop,
      style: const TextStyle(color: Colors.grey, fontSize: 18),
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 40);

    if (textPainter.didExceedMaxLines) {
      setState(() {
        isOverflowing = true;
      });
    }
  }

  double _calculateTotalAmount(List<ShopService> services) {
    double total = 0.0;
    for (var service in services) {
      // Assuming serviceCharge is a String that can be converted to a double
      final charge = int.tryParse(service.serviceCharge ?? '0') ?? 0;
      total += charge;
    }
    return total;
  }

  UserModel? user;
  double? tAmount;
  String status = "Pending";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now(); // Default to current time
  String finalDate = "";
  Shop? _shop;

  Future<String> registerBooking() async {
    showLoadingDialog(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userJson = prefs.getString("user");
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        user = UserModel.fromJson(userMap);
      });
    }

    DatabaseReference ref = FirebaseDatabase.instance.ref("Booking");
    DatabaseReference bookingRef = ref.push();
    Booking booking = Booking(
      reachOutTime: selectedTime.format(context),
      bookingId: bookingRef.key.toString(),
      numberOfSeatorTable: 0,
      userId: user!.uId!,
      shopNumber: _shop!.shopNumber!,
      userNumber: user!.number!,
      shopId: _shop!.shopId!,
      shopName: _shop!.shopName!,
      shopAddress: _shop!.shopAddress!,
      shopCategory: _shop!.shopCategory!,
      date: finalDate,
      shopServices: selectedServices,
      totalFee: tAmount.toString(),
      customerName: user!.name!,
      status: status,
    );
    // print("Booking - ${booking.toJson()}");
    try {
      await bookingRef.set(booking.toJson());
      if (mounted) {
        dismissLoadingDialog(); // Dismiss the loading dialog
        return bookingRef.key.toString();
      }
    } catch (e) {
      // print(e);
      dismissLoadingDialog();
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.sizeOf(context).height * 0.45;

    final Shop shop = arguments?['shop'];
    final List<ShopService>? shopServices = shop.shopServices;

    final String formattedDate =
        '${selectedDate.day.toString().padLeft(2, '0')}/'
        '${selectedDate.month.toString().padLeft(2, '0')}/'
        '${selectedDate.year.toString().substring(2)}'; // Getting last two digits of the year

    setState(() {
      _shop = shop;
      finalDate = formattedDate;
    });

    // print(_shop?.toJson());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    width: screenWidth,
                    height: screenHeight,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(shop.shopImageUrl ?? ""),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                // Shop name
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            shop.shopName ?? "",
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          shop.startTime != null
                              ? Text(
                                  "${shop.startTime} - ${shop.endTime}",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                )
                              : Text(
                                  "${shop.mStartTime} - ${shop.mEndTime} | ${shop.eStartTime} - ${shop.eEndTime}",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ],
                      ),
                      get10height(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              shop.shopAddress ?? "",
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.white),
                            ),
                          ),
                          get10height(),
                          TextButton.icon(
                            icon: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Navigate",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () async {
                              final Uri uri = Uri.parse(shop.mapLink ?? "");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                // Optionally show a snackbar or dialog for error feedback
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Could not launch ${shop.mapLink}'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "About Us",
                        style: TextStyle(fontSize: 25),
                      ),
                      get10height(),
                      AnimatedCrossFade(
                        firstChild: Text(
                          shop.shopAbout ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        secondChild: Text(
                          shop.shopAbout ?? "",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          isExpanded ? 'Read less' : 'Read more',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Booking Date - $formattedDate",
                            style: const TextStyle(fontSize: 17),
                          ),
                          TextButton(
                            child: const Icon(Icons.calendar_month_rounded),
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Reachout Time - ${selectedTime.format(context)}",
                            style: const TextStyle(fontSize: 17),
                          ),
                          TextButton(
                            onPressed: () {
                              _selectTime(context);
                            },
                            child: const Icon(Icons.access_time_rounded),
                          ),
                        ],
                      ),
                      const Text(
                        "Note :- Reachout time must be between shop starting time and ending time",
                        style: TextStyle(fontSize: 16),
                      ),
                      if (shopServices?.isNotEmpty ?? false)
                        Column(
                          children: [
                            get10height(),
                            const Text(
                              "Services",
                              style: TextStyle(fontSize: 25),
                            ),
                          ],
                        ),
                      if (shopServices?.isNotEmpty ?? false)
                        SizedBox(
                          height: 250, // Approximate height per item
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final service = shopServices?[index];
                              return CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: selectedServices.contains(service),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedServices.add(service!);
                                    } else {
                                      selectedServices.remove(service);
                                    }
                                    final totalAmount =
                                        _calculateTotalAmount(selectedServices);
                                    tAmount = totalAmount;
                                  });
                                },
                                title: Text(
                                  "${service?.serviceName}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "Approx time - ${service?.serviceDuration} ${service?.minOrHr}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                secondary: Text(
                                  "₹${service?.serviceCharge}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            },
                            itemCount: shopServices?.length,
                          ),
                        ),
                      get10height(),
                      getMainButton(
                        onPressed: () async {
                          if (shop.shopCategory == "Salon") {
                            if (selectedServices.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Please select at least a service"),
                                ),
                              );
                              return;
                            }
                          }
                          String bookingID = await registerBooking();
                          if (!mounted) return;
                          Navigator.pushNamed(context, "/summary_screen_screen",
                              arguments: {"bookingID": bookingID});
                        },
                        name: "Sent Request",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // Update the selected date
      });
    }
  }

  // Function to show the time picker dialog
  Future<void> _selectTime(BuildContext context) async {
    // Show the time picker and wait for the user to select a time
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime, // Set the initial time
    );

    // If the user selects a time (not null), update the selected time
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }
}
