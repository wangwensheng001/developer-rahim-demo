// To parse this JSON data, do
//
//     final pickupPointListResponse = pickupPointListResponseFromJson(jsonString);

import 'dart:convert';

PickupPointListResponse pickupPointListResponseFromJson(String str) => PickupPointListResponse.fromJson(json.decode(str));

String pickupPointListResponseToJson(PickupPointListResponse data) => json.encode(data.toJson());

class PickupPointListResponse {
  PickupPointListResponse({
    this.result,
    this.pickupPoints,
  });

  bool result;
  List<PickupPoint> pickupPoints;

  factory PickupPointListResponse.fromJson(Map<String, dynamic> json) => PickupPointListResponse(
    result: json["result"],
    pickupPoints: List<PickupPoint>.from(json["pickup_points"].map((x) => PickupPoint.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "pickup_points": List<dynamic>.from(pickupPoints.map((x) => x.toJson())),
  };
}

class PickupPoint {
  PickupPoint({
    this.id,
    this.staffId,
    this.name,
    this.address,
    this.phone,
    this.pickUpStatus,
    this.cashOnPickupStatus,
    this.createdAt,
    this.updatedAt,
    this.pickupPointTranslations,
  });

  int id;
  int staffId;
  String name;
  String address;
  String phone;
  int pickUpStatus;
  dynamic cashOnPickupStatus;
  DateTime createdAt;
  DateTime updatedAt;
  List<PickupPointTranslation> pickupPointTranslations;

  factory PickupPoint.fromJson(Map<String, dynamic> json) => PickupPoint(
    id: json["id"],
    staffId: json["staff_id"],
    name: json["name"],
    address: json["address"],
    phone: json["phone"],
    pickUpStatus: json["pick_up_status"],
    cashOnPickupStatus: json["cash_on_pickup_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    pickupPointTranslations: List<PickupPointTranslation>.from(json["pickup_point_translations"].map((x) => PickupPointTranslation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "staff_id": staffId,
    "name": name,
    "address": address,
    "phone": phone,
    "pick_up_status": pickUpStatus,
    "cash_on_pickup_status": cashOnPickupStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "pickup_point_translations": List<dynamic>.from(pickupPointTranslations.map((x) => x.toJson())),
  };
}

class PickupPointTranslation {
  PickupPointTranslation({
    this.id,
    this.pickupPointId,
    this.name,
    this.address,
    this.lang,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int pickupPointId;
  String name;
  String address;
  String lang;
  DateTime createdAt;
  DateTime updatedAt;

  factory PickupPointTranslation.fromJson(Map<String, dynamic> json) => PickupPointTranslation(
    id: json["id"],
    pickupPointId: json["pickup_point_id"],
    name: json["name"],
    address: json["address"],
    lang: json["lang"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "pickup_point_id": pickupPointId,
    "name": name,
    "address": address,
    "lang": lang,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
