import 'package:ezybook/models/booking.dart';
import 'package:ezybook/models/shopservice.dart';
import 'package:ezybook/widgets/sizedbox.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  double _calculateTotalAmount(List<ShopService> services) {
    double total = 0.0;

    for (var service in services) {
      // Assuming serviceCharge is a String that can be converted to a double
      final charge = int.tryParse(service.serviceCharge ?? '0') ?? 0;
      total += charge;
    }

    return total;
  }

  void registerBooking() async {
    // Booking booking = Booking(serviceList: serviceList, totalFee: totalFee, customerName: customerName, status: status)
    DatabaseReference ref = FirebaseDatabase.instance.ref("Booking");
    DatabaseReference bookingRef = ref.push();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String name = arguments?['name'] ?? 'Unknown Shop';
    final String location = arguments?['location'] ?? 'Unknown Location';
    final List<ShopService> shopServices = arguments?['selectedServices'] ?? [];

    // Calculate total amount
    final totalAmount = _calculateTotalAmount(shopServices);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                "Request Send",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              get10height(),
              Image.asset(
                'assets/images/bookingdone.gif',
                fit: BoxFit.cover,
              ),
              get10height(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.store),
                  Text(
                    name,
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
                      location,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
              get10height(),
              // Displaying shop services
              const Text(
                "Selected Services",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              get10height(),
              ListView(
                shrinkWrap: true,
                children: shopServices.map((shopService) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          shopService.serviceName ?? 'No Name',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          shopService.serviceCharge ?? 'No Charge',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              get10height(),
              const Text(
                "Status - Pending",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Displaying the total amount
              get10height(),
              Text(
                "Total Amount: ₹$totalAmount",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              get10height(),
              ElevatedButton.icon(
                label: const Text(
                  "Chat with Owner",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {},
                icon: const Icon(
                  Icons.chat,
                  size: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
