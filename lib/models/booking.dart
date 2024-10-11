import 'package:ezybook/models/shopservice.dart';

class Booking {
  String userId;
  String shopId;
  String date;
  List<ShopService> serviceList;
  String totalFee;
  String customerName;
  String status;

  Booking({
    required this.userId,
    required this.shopId,
    required this.date,
    required this.serviceList,
    required this.totalFee,
    required this.customerName,
    required this.status,
  });

  Booking.fromJson(Map<String, dynamic> json)
      : serviceList = (json['serviceList'] as List)
            .map((service) => ShopService.fromJson(service))
            .toList(),
        totalFee = json['totalFee'] as String,
        customerName = json['customerName'] as String,
        status = json['status'] as String,
        userId = json['userId'] as String,
        shopId = json['shopId'] as String,
        date = json['date'] as String;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceList'] =
        serviceList.map((service) => service.toJson()).toList();
    data['totalFee'] = totalFee;
    data['customerName'] = customerName;
    data['status'] = status;
    data['userId'] = userId;
    data['shopId'] = shopId;
    data['date'] = date;
    return data;
  }
}
