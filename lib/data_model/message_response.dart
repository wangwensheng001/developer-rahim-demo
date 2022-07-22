// To parse this JSON data, do
//
//     final messageResponse = messageResponseFromJson(jsonString);

import 'dart:convert';

MessageResponse messageResponseFromJson(String str) => MessageResponse.fromJson(json.decode(str));

String messageResponseToJson(MessageResponse data) => json.encode(data.toJson());

class MessageResponse {
  MessageResponse({
    this.messages,
    this.meta,
    this.success,
    this.status,
  });

  List<Message> messages;
  Meta meta;
  bool success;
  int status;

  factory MessageResponse.fromJson(Map<String, dynamic> json) => MessageResponse(
    messages: List<Message>.from(json["data"].map((x) => Message.fromJson(x))),
    meta: Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(messages.map((x) => x.toJson())),
    "meta": meta.toJson(),
    "success": success,
    "status": status,
  };
}

class Message {
  Message({
    this.id,
    this.user_id,
    this.message,
    this.date,
    this.time,
  });

  int id;
  int user_id;
  String message;
  String date;
  String time;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    user_id: json["user_id"],
    message: json["message"],
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": user_id,
    "message": message,
    "date": date,
    "time": time,
  };
}


class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}
