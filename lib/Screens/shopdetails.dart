import 'dart:convert';

import 'package:ezybook/models/booking.dart';
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
    final String aboutShop = arguments?['aboutshop'] ?? 'Not available';

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
  String? sId;
  double? tAmount;
  String status = "Pending";
  DateTime selectedDate = DateTime.now();
  String finalDate = "";

  Future<bool?> registerBooking() async {
    showLoadingDialog(context);
    bool success = false;
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
      bookingId: bookingRef.key.toString(),
      numberOfSeatorTable: 0,
      userId: user!.uId!,
      shopId: sId!,
      date: finalDate,
      serviceList: selectedServices,
      totalFee: tAmount.toString(),
      customerName: user!.name!,
      status: status,
    );
    // print("Booking - ${booking.toJson()}");
    try {
      await bookingRef.set(booking.toJson());
      if (mounted) {
        dismissLoadingDialog(); // Dismiss the loading dialog
        success = true;
      }
    } catch (e) {
      // print(e);
      dismissLoadingDialog();
      success = false;
    }
    return success;
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.sizeOf(context).height * 0.45;

    final String shopName = arguments?['name'] ?? 'Unknown Shop';
    final String location = arguments?['location'] ?? 'Unknown Location';
    final String mainImage = arguments?['image'] ?? 'assets/images/Im1.png';
    final String aboutShop = arguments?['aboutshop'] ?? 'Not available';
    final String startTime = arguments?['openingTime'] ?? "";
    final String endTime = arguments?['endTime'] ?? "";
    final String mStartTime = arguments?['mStartTime'] ?? "";
    final String mEndTime = arguments?['mEndTime'] ?? "";
    final String eStartTime = arguments?['eStartTime'] ?? "";
    final String eEndTime = arguments?['eEndTime'] ?? "";
    final String mapLink = arguments?['mapLink'] ?? "";
    final String shopId = arguments?['shopId'] ?? 'Not available';

    final List<ShopService>? shopServices = arguments?['shopServices'] ?? [];

    final String formattedDate =
        '${selectedDate.day.toString().padLeft(2, '0')}/'
        '${selectedDate.month.toString().padLeft(2, '0')}/'
        '${selectedDate.year.toString().substring(2)}'; // Getting last two digits of the year

    setState(() {
      sId = shopId;
      finalDate = formattedDate;
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        image: NetworkImage(mainImage),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            shopName,
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          startTime.isNotEmpty
                              ? Text(
                                  "$startTime - $endTime",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                )
                              : Text(
                                  "$mStartTime - $mEndTime | $eStartTime - $eEndTime",
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
                              location,
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
                              final Uri uri = Uri.parse(mapLink);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                // Optionally show a snackbar or dialog for error feedback
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Could not launch $mapLink'),
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
                      Text(
                        aboutShop,
                        maxLines: isExpanded ? null : 2,
                        overflow: isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      if (isOverflowing)
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
                      get10height(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Booking Date - $formattedDate",
                            style: const TextStyle(fontSize: 17),
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _selectDate(context);
                            },
                            label: const Text("Change Date"),
                          ),
                        ],
                      ),
                      get10height(),
                      if (shopServices?.isNotEmpty ?? false)
                        const Text(
                          "Services",
                          style: TextStyle(fontSize: 25),
                        ),
                      get10height(),
                      if (shopServices?.isNotEmpty ?? false)
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              final service = shopServices?[index];
                              return ListTile(
                                leading: Checkbox(
                                  value: selectedServices.contains(service),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedServices.add(service!);
                                      } else {
                                        selectedServices.remove(service);
                                      }
                                      final totalAmount = _calculateTotalAmount(
                                          selectedServices);
                                      tAmount = totalAmount;
                                    });
                                  },
                                ),
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
                                trailing: Text(
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
                          if (selectedServices.isNotEmpty) {
                            bool? success = await registerBooking();
                            if (success ?? false) {
                              Navigator.pushNamed(
                                context,
                                "/summary_screen_screen",
                                arguments: {
                                  "name": shopName,
                                  "selectedServices": selectedServices,
                                  "location": location,
                                  "date": finalDate,
                                  "totalAmount": tAmount,
                                  "status": status,
                                },
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Internal Error"),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Please select at least a service"),
                              ),
                            );
                          }
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
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // Update the selected date
      });
    }
  }
}
