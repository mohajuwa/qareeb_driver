import 'dart:convert';

IAmHereModel iAmHereModelFromJson(String str) => IAmHereModel.fromJson(json.decode(str));

String iAmHereModelToJson(IAmHereModel data) => json.encode(data.toJson());

class IAmHereModel {
  int responseCode;
  bool result;
  String message;
  num driverWaitTime;

  IAmHereModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.driverWaitTime,
  });

  factory IAmHereModel.fromJson(Map<String, dynamic> json) => IAmHereModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    driverWaitTime: json["driver_wait_time"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "driver_wait_time": driverWaitTime,
  };
}
