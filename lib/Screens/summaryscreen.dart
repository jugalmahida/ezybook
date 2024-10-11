import 'package:ezybook/models/shopservice.dart';
import 'package:ezybook/widgets/sizedbox.dart';
import 'package:flutter/material.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String name = arguments?['name'] ?? 'Unknown Shop';
    final String status = arguments?['status'] ?? 'Unknown Status';
    final double totalAmount = arguments?['totalAmount'] ?? 0.0;
    final String location = arguments?['location'] ?? 'Unknown Location';
    final String date = arguments?['date'] ?? 'Unknown Date';
    final List<ShopService> shopServices = arguments?['selectedServices'] ?? [];

    // Calculate total amount

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/bookingdone.gif',
                fit: BoxFit.cover,
              ),
              get10height(),
              const Text(
                "Request Send to Owner",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              get10height(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.store),
                  const SizedBox(
                    width: 10,
                  ),
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
                  const Icon(Icons.calendar_month),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    date,
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
              Text(
                "Status - $status",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
