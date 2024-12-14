import 'package:ezybook/models/shopservice.dart';

class Booking {
  String bookingId;
  String userId;
  String userNumber;
  String shopId;
  String shopCategory;
  String shopNumber;
  String shopName;
  String shopAddress;
  String date;
  String reachOutTime;
  List<ShopService>? shopServices;
  String? totalFee;
  String customerName;
  String status;
  String? cancelReason;
  int numberOfSeatorTable;

  Booking({
    required this.bookingId,
    required this.userId,
    required this.userNumber,
    required this.shopId,
    required this.shopCategory,
    required this.shopNumber,
    required this.shopName,
    required this.shopAddress,
    required this.date,
    required this.reachOutTime,
    this.shopServices,
    this.totalFee,
    required this.customerName,
    required this.status,
    this.cancelReason,
    required this.numberOfSeatorTable,
  });

  factory Booking.fromJson(Map<String, dynamic> json, String bookingId) {
    final servicesMap = json['shopServices'] as Map<dynamic, dynamic>?;

    List<ShopService>? shopServices;
    if (servicesMap != null) {
      shopServices = servicesMap.entries
          .map((entry) {
            final serviceId = entry.key.toString();
            final serviceData = entry.value;

            if (serviceData is Map<dynamic, dynamic>) {
              // Convert the nested map to a ShopService object
              return ShopService.fromJson(
                  Map<String, dynamic>.from(serviceData), serviceId);
            }
            return null; // Skip invalid entries
          })
          .whereType<ShopService>()
          .toList();
    } else {
      shopServices = []; // Default to an empty list if null
    }

    return Booking(
      bookingId: bookingId,
      userId: json['userId'] ?? '',
      shopId: json['shopId'] ?? '',
      userNumber: json['userNumber'],
      shopNumber: json['shopNumber'],
      shopCategory: json['shopCategory'] ?? '',
      shopName: json['shopName'] ?? '',
      shopAddress: json['shopAddress'] ?? '',
      date: json['date'] ?? '',
      reachOutTime: json['reachOutTime'] ?? '',
      shopServices: shopServices,
      totalFee: json['totalFee']?.toString(),
      customerName: json['customerName'] ?? '',
      status: json['status'] ?? '',
      cancelReason: json['cancelReason'],
      numberOfSeatorTable: json['numberOfSeatorTable'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shopServices != null) {
      // Convert List<ShopService> to a Map with serviceId as the key
      data['shopServices'] = {
        for (var service in shopServices!) service.serviceId!: service.toJson(),
      };
    }
    data['userNumber'] = userNumber;
    data['shopNumber'] = shopNumber;
    data['bookingId'] = bookingId;
    data['numberOfSeatorTable'] = numberOfSeatorTable;
    data['totalFee'] = totalFee;
    data['customerName'] = customerName;
    data['status'] = status;
    data['cancelReason'] = cancelReason;
    data['userId'] = userId;
    data['shopId'] = shopId;
    data['shopName'] = shopName;
    data['shopCategory'] = shopCategory;
    data['shopAddress'] = shopAddress;
    data['date'] = date;
    data['reachOutTime'] = reachOutTime;
    return data;
  }
}
