import 'package:flutter/material.dart';

class ShopDetails extends StatefulWidget {
  const ShopDetails({super.key});

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  bool isExpanded = false; // State to track if text is expanded
  bool isOverflowing = false; // State to track if the text is overflowing

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

    textPainter.layout(
        maxWidth: MediaQuery.of(context).size.width -
            40); // Adjust width based on your layout

    if (textPainter.didExceedMaxLines) {
      setState(() {
        isOverflowing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.sizeOf(context).height * 0.55;

    // Use default values or handle missing arguments
    final String name = arguments?['name'] ?? 'Unknown Shop';
    final String charge = arguments?['charge'] ?? 'Unknown Charge';
    final String location = arguments?['location'] ?? 'Unknown Location';
    final String mainImage = arguments?['image'] ?? 'assets/images/Im1.png';
    final String aboutShop =
        arguments?['aboutshop'] ?? 'Not available'; // Corrected key

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop Details"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main image
          Image.asset(
            mainImage,
            width: screenWidth,
            height: screenheight,
            fit: BoxFit.fill,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop name
                    Text(
                      name,
                      style: const TextStyle(fontSize: 25),
                    ),
                    // Shop location
                    Row(
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/images/location.png"),
                            const SizedBox(width: 5),
                            Text(
                              location,
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Fees per client - $charge",
                      style: const TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                    // Other details
                    const SizedBox(height: 10),
                    // About section
                    const Text(
                      "About Shop",
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 10),
                    // AboutShop Text with "Read more" / "Read less" functionality
                    Text(
                      aboutShop,
                      maxLines: isExpanded ? null : 4,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    if (isOverflowing)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded; // Toggle expanded state
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
                    const SizedBox(height: 20),
                    // View Time Table button
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF24BAEC)),
                              onPressed: () => {
                                Navigator.pushNamed(
                                  context,
                                  "/time_table_screen",
                                  arguments: {
                                    'name': name,
                                    'charge': charge,
                                    'location': location,
                                    'image': mainImage,
                                  },
                                )
                              },
                              child: const Text(
                                'View Time Table',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
