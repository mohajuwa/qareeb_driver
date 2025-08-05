import 'dart:convert';

OtpRideModel otpRideModelFromJson(String str) => OtpRideModel.fromJson(json.decode(str));

String otpRideModelToJson(OtpRideModel data) => json.encode(data.toJson());

class OtpRideModel {
  int responseCode;
  bool result;
  String message;

  OtpRideModel({
    required this.responseCode,
    required this.result,
    required this.message,
  });

  factory OtpRideModel.fromJson(Map<String, dynamic> json) => OtpRideModel(
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
