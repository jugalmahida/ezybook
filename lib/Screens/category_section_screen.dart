import 'package:ezybook/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class CategorySection extends StatefulWidget {
  final String category;
  final List<Shop?> allshopDetails;

  const CategorySection({
    super.key,
    required this.category,
    required this.allshopDetails,
  });

  @override
  _CategorySectionState createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.height * 0.26;
    double rowSize = MediaQuery.of(context).size.height * 0.38;

    List<Shop?> topFiveShops = widget.allshopDetails.take(5).toList();

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
          height: rowSize,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topFiveShops.length,
            itemBuilder: (BuildContext context, int index) {
              final shop = topFiveShops[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/shop_details_screen",
                    arguments: {
                      'shopId': shop?.shopId,
                      'name': shop?.shopName,
                      'location': shop?.shopAddress,
                      'image': shop?.shopImageUrl,
                      'aboutshop': shop?.shopAbout,
                      'openingTime': shop?.startTime,
                      'endTime': shop?.endTime,
                      'mStartTime': shop?.mStartTime,
                      'mEndTime': shop?.mEndTime,
                      'eStartTime': shop?.eStartTime,
                      'eEndTime': shop?.eEndTime,
                      'mapLink': shop?.mapLink,
                      'shopServices': shop?.shopServices,
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          shop?.shopImageUrl ?? "",
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child; // The image has loaded
                            } else {
                              // Show the skeleton while loading
                              return SkeletonAnimation(
                                child: Container(
                                  width: imageSize,
                                  height: imageSize,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const SizedBox(width: 5),
                          Text(
                            shop?.shopName ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
