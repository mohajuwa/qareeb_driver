import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  int responseCode;
  bool result;
  String message;

  NotificationModel({
    required this.responseCode,
    required this.result,
    required this.message,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
  };
}
