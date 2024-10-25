import 'package:ezybook/models/booking.dart';
import 'package:ezybook/widgets/sizedbox.dart';
import 'package:flutter/material.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});
  static Booking? booking;

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  String isSeatorTable = "";

  @override
  void initState() {
    super.initState();
    if (SummaryScreen.booking!.shopCategory == "Salon") {
      isSeatorTable = "Seat";
    } else {
      isSeatorTable = "Table";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SummaryScreen.booking?.status == "Accepted"
                  ? Column(
                      children: [
                        Image.asset(
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
                          children: SummaryScreen.booking!.serviceList!
                              .map((shopService) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                      ],
                    )
                  : const SizedBox(),
              get10height(),
              Text(
                "Status - ${SummaryScreen.booking?.status}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

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
