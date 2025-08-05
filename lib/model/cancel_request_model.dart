import 'dart:convert';

CancelRequestModel cancelRequestModelFromJson(String str) => CancelRequestModel.fromJson(json.decode(str));

String cancelRequestModelToJson(CancelRequestModel data) => json.encode(data.toJson());

class CancelRequestModel {
  int responseCode;
  bool result;
  String message;

  CancelRequestModel({
    required this.responseCode,
    required this.result,
    required this.message,
  });

  factory CancelRequestModel.fromJson(Map<String, dynamic> json) => CancelRequestModel(
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
