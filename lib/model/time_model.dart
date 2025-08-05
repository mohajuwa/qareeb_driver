import 'dart:convert';

TimeModel timeModelFromJson(String str) => TimeModel.fromJson(json.decode(str));

String timeModelToJson(TimeModel data) => json.encode(data.toJson());

class TimeModel {
  int responseCode;
  bool result;
  String message;

  TimeModel({
    required this.responseCode,
    required this.result,
    required this.message,
  });

  factory TimeModel.fromJson(Map<String, dynamic> json) => TimeModel(
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
