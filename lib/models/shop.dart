import 'package:ezybook/models/shopservice.dart';

class Shop {
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
  List<ShopService>? shopServices;

  Shop({
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
    this.shopServices,
  });
  factory Shop.fromJson(Map<String, dynamic> json) {
    // Get the list of shop services, or null if not present
    List<dynamic>? s = json['shopServices'];

    // If 'shopServices' is not null, map it to a list of ShopService
    List<ShopService>? sl = s != null
        ? s
            .map((element) =>
                ShopService.fromJson(element.cast<String, dynamic>()))
            .toList()
        : null;

    return Shop(
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
      shopServices: sl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'shopServices': shopServices,
    };
  }

  static List<Shop?> allShops = [];
}
