import 'dart:convert';

AcceptRequestModel acceptRequestModelFromJson(String str) => AcceptRequestModel.fromJson(json.decode(str));

String acceptRequestModelToJson(AcceptRequestModel data) => json.encode(data.toJson());

class AcceptRequestModel {
  int responseCode;
  bool result;
  String message;

  AcceptRequestModel({
    required this.responseCode,
    required this.result,
    required this.message,
  });

  factory AcceptRequestModel.fromJson(Map<String, dynamic> json) => AcceptRequestModel(
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
