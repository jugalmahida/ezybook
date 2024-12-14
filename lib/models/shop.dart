import 'package:ezybook/models/shopservice.dart';

class Shop {
  String? shopId;
  String? shopImageUrl;
  String? shopCategory;
  String? shopName;
  String? shopNumber;
  String? shopAddress;
  String? shopAbout;
  String? oName;
  String? oNumber;
  String? oEmail;
  String? oPassword;
  String? startTime;
  String? endTime;
  String? mStartTime;
  String? mEndTime;
  String? eStartTime;
  String? eEndTime;
  String? seatOrTable;
  String? mapLink;

  List<ShopService>? shopServices;

  Shop({
    this.shopId,
    this.shopImageUrl,
    this.shopCategory,
    this.shopName,
    this.shopNumber,
    this.shopAddress,
    this.shopAbout,
    this.oName,
    this.oNumber,
    this.oEmail,
    this.oPassword,
    this.startTime,
    this.endTime,
    this.mStartTime,
    this.mEndTime,
    this.eStartTime,
    this.eEndTime,
    this.seatOrTable,
    this.mapLink,
    this.shopServices,
  });
  factory Shop.fromJson(Map<String, dynamic> json, String shopId) {
    List<ShopService>? sl = [];
    Map<Object?, Object?>? s = json['shopServices'];
    if (s != null && s.isNotEmpty) {
      s.forEach((key, value) {
        if (value is Map<Object?, Object?>) {
          ShopService shopService = ShopService.fromJson(
              value.cast<String, dynamic>(), key.toString());
          sl.add(shopService);
        }
      });
    }
    return Shop(
      shopId: shopId,
      shopImageUrl: json['shopImageUrl'],
      shopCategory: json['shopCategory'],
      shopName: json['shopName'],
      shopNumber: json['shopNumber'],
      shopAddress: json['shopAddress'],
      shopAbout: json['shopAbout'],
      oName: json['oName'],
      oNumber: json['oNumber'],
      oEmail: json['oEmail'],
      oPassword: json['oPassword'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      mStartTime: json['mStartTime'],
      mEndTime: json['mEndTime'],
      eStartTime: json['eStartTime'],
      eEndTime: json['eEndTime'],
      seatOrTable: json['seatOrTable'],
      mapLink: json['mapLink'],
      shopServices: sl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'shopImageUrl': shopImageUrl,
      'shopCategory': shopCategory,
      'shopName': shopName,
      'shopNumber': shopNumber,
      'shopAddress': shopAddress,
      'shopAbout': shopAbout,
      'oName': oName,
      'oNumber': oNumber,
      'oEmail': oEmail,
      'oPassword': oPassword,
      'startTime': startTime,
      'endTime': endTime,
      'mStartTime': mStartTime,
      'mEndTime': mEndTime,
      'eStartTime': eStartTime,
      'eEndTime': eEndTime,
      'seatOrTable': seatOrTable,
      'mapLink': mapLink,
      'shopServices': shopServices?.map((service) => service.toJson()).toList(),
    };
  }

  static List<Shop?> allShops = [];
}
