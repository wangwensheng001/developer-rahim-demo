// To parse this JSON data, do
//
//     final flashDealResponse = flashDealResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

FlashDealResponse flashDealResponseFromJson(String str) => FlashDealResponse.fromJson(json.decode(str));

String flashDealResponseToJson(FlashDealResponse data) => json.encode(data.toJson());

class FlashDealResponse {
  FlashDealResponse({
    this.flash_deals,
    this.success,
    this.status,
  });

  List<FlashDeal> flash_deals;
  bool success;
  int status;

  factory FlashDealResponse.fromJson(Map<String, dynamic> json) => FlashDealResponse(
    flash_deals: List<FlashDeal>.from(json["data"].map((x) => FlashDeal.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(flash_deals.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class FlashDeal {
  FlashDeal({
    this.id,
    this.title,
    this.date,
    this.banner,
  });

  int id;
  String title;
  int date;
  String banner;

  factory FlashDeal.fromJson(Map<String, dynamic> json) => FlashDeal(
    id: json["id"],
    title: json["title"],
    date: json["date"],
    banner: json["banner"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "date": date,
    "banner": banner,
  };
}
