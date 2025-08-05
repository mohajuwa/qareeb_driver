import 'dart:convert';

BackgroundMessageModel backgroundMessageModelFromJson(String str) => BackgroundMessageModel.fromJson(json.decode(str));

String backgroundMessageModelToJson(BackgroundMessageModel data) => json.encode(data.toJson());

class BackgroundMessageModel {
  int responseCode;
  bool result;
  String message;

  BackgroundMessageModel({
    required this.responseCode,
    required this.result,
    required this.message,
  });

  factory BackgroundMessageModel.fromJson(Map<String, dynamic> json) => BackgroundMessageModel(
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
