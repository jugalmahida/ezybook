import 'package:ezybook/models/shopservice.dart';
import 'package:ezybook/widgets/button.dart';
import 'package:ezybook/widgets/sizedbox.dart';
import 'package:flutter/material.dart';

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
      maxLines: 4,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 40);

    if (textPainter.didExceedMaxLines) {
      setState(() {
        isOverflowing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.sizeOf(context).height * 0.45;

    final String name = arguments?['name'] ?? 'Unknown Shop';
    final String location = arguments?['location'] ?? 'Unknown Location';
    final String mainImage = arguments?['image'] ?? 'assets/images/Im1.png';
    final String aboutShop = arguments?['aboutshop'] ?? 'Not available';
    final String startTime = arguments?['openingTime'] ?? "";
    final String endTime = arguments?['endTime'] ?? "";
    final String mStartTime = arguments?['mStartTime'] ?? "";
    final String mEndTime = arguments?['mEndTime'] ?? "";
    final String eStartTime = arguments?['eStartTime'] ?? "";
    final String eEndTime = arguments?['eEndTime'] ?? "";

    final List<ShopService>? shopServices = arguments?['shopServices'] ?? [];

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
                            name,
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
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          get10height(),
                          Expanded(
                            child: Text(
                              location,
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.white),
                            ),
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
                        maxLines: isExpanded ? null : 4,
                        overflow: isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 18),
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
                          height: 150,
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
                      getMainButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            "/time_table_screen",
                            arguments: {
                              'name': name,
                              'location': location,
                              'image': mainImage,
                            },
                          );
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
}
