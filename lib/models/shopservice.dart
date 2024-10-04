class ShopService {
  String? serviceName;
  String? serviceDuration;
  String? minOrHr;
  String? serviceCharge;

  ShopService({
    this.serviceName,
    this.serviceDuration,
    this.minOrHr,
    this.serviceCharge,
  });

  // Create a ShopService instance from a JSON map
  factory ShopService.fromJson(Map<String, dynamic> json) {
    return ShopService(
      serviceName: json['serviceName'],
      serviceDuration: json['serviceDuration'],
      minOrHr: json['minOrHr'],
      serviceCharge: json['serviceCharge'],
    );
  }

  // Convert a ShopService instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceName,
      'serviceDuration': serviceDuration,
      'minOrHr': minOrHr,
      'serviceCharge': serviceCharge,
    };
  }
}
