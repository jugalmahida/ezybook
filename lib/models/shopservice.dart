class ShopService {
  String? serviceId;
  String? serviceName;
  String? serviceDuration;
  String? minOrHr;
  String? serviceCharge;

  ShopService({
    this.serviceId,
    this.serviceName,
    this.serviceDuration,
    this.minOrHr,
    this.serviceCharge,
  });

  // Create a ShopService instance from a JSON map
  factory ShopService.fromJson(Map<String, dynamic> json, String? serviceId) {
    return ShopService(
      serviceId: serviceId,
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
