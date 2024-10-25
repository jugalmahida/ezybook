import 'package:ezybook/models/shopservice.dart';

class Booking {
  String bookingId;
  String userId;
  String shopId;
  String shopCategory;
  String shopName;
  String shopAddress;
  String date;
  List<ShopService>? serviceList;
  String? totalFee;
  String customerName;
  String status;
  int numberOfSeatorTable;

  Booking({
    required this.bookingId,
    required this.userId,
    required this.shopId,
    required this.shopCategory,
    required this.shopName,
    required this.shopAddress,
    required this.date,
    this.serviceList,
    this.totalFee,
    required this.customerName,
    required this.status,
    required this.numberOfSeatorTable,
  });

  factory Booking.fromJson(Map<String, dynamic> json, String bookingId) {
    // Get the list of shop services, or null if not present
    List<dynamic>? s = json['serviceList'];

    // If 'shopServices' is not null, map it to a list of ShopService
    List<ShopService>? sl = s
        ?.map(
            (element) => ShopService.fromJson(element.cast<String, dynamic>()))
        .toList();

    return Booking(
      bookingId: bookingId,
      userId: json['userId'],
      shopId: json['shopId'],
      shopCategory: json['shopCategory'],
      shopName: json['shopName'],
      shopAddress: json['shopAddress'],
      date: json['date'],
      serviceList: sl,
      totalFee: json['totalFee'],
      customerName: json['customerName'],
      status: json['status'],
      numberOfSeatorTable: json['numberOfSeatorTable'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceList'] =
        serviceList?.map((service) => service.toJson()).toList();
    data['bookingId'] = bookingId;
    data['numberOfSeatorTable'] = numberOfSeatorTable;
    data['totalFee'] = totalFee;
    data['customerName'] = customerName;
    data['status'] = status;
    data['userId'] = userId;
    data['shopId'] = shopId;
    data['shopName'] = shopName;
    data['shopCategory'] = shopCategory;
    data['shopAddress'] = shopAddress;
    data['date'] = date;
    return data;
  }
}
