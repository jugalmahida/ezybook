import 'package:flutter/material.dart';

class CategorySection extends StatefulWidget {
  final String category;
  final List<Map<String, String>> allshopDetails;

  const CategorySection({
    super.key,
    required this.category,
    required this.allshopDetails,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CategorySectionState createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  // Initialize a map to track favorite status of each shop

  @override
  Widget build(BuildContext context) {
    // Convert and sort the shops based on their rating
    List<Map<String, String>> sortedShopDetails =
        List.from(widget.allshopDetails);
    sortedShopDetails.sort((a, b) {
      double ratingA = double.parse(a['rating']!);
      double ratingB = double.parse(b['rating']!);
      return ratingB.compareTo(ratingA); // Descending order
    });

    List<Map<String, String>> topFiveShops = sortedShopDetails.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
          child: Text(
            "Best ${widget.category}!",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5.0),
        SizedBox(
          height: 317.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topFiveShops.length,
            itemBuilder: (BuildContext context, int index) {
              final shop = topFiveShops[index];
              // final shopName = shop['name']!;
              // final isFavorite = _favorites[shopName] ?? false;

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/shop_details_screen",
                    arguments: {
                      'name': shop['name'],
                      'charge': "₹${shop['price']}",
                      'location': shop['location'],
                      'image': shop['mainimage'],
                      'rating': shop['rating'],
                      'aboutshop': shop['aboutshop'],
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            width: 250,
                            height: 250,
                            shop['mainimage']!,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              Text(
                                shop['name']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              Image.asset("assets/images/Star.png"),
                              const SizedBox(width: 5),
                              Text(shop['rating']!),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              Image.asset("assets/images/location.png"),
                              const SizedBox(width: 10),
                              Text(
                                shop['location']!,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Positioned(
                      //   right: 8,
                      //   top: 8,
                      //   child: IconButton(
                      //     icon: Icon(
                      //       isFavorite ? Icons.favorite : Icons.favorite_border,
                      //       color: isFavorite ? Colors.red : Colors.white,
                      //     ),
                      //     onPressed: () => _toggleFavorite(shopName),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
