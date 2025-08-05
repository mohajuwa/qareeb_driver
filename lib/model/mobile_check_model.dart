import 'dart:convert';

MobileCheckModel mobileCheckModelFromJson(String str) => MobileCheckModel.fromJson(json.decode(str));

String mobileCheckModelToJson(MobileCheckModel data) => json.encode(data.toJson());

class MobileCheckModel {
  int responseCode;
  bool result;
  String message;

  MobileCheckModel({
    required this.responseCode,
    required this.result,
    required this.message,
  });

  factory MobileCheckModel.fromJson(Map<String, dynamic> json) => MobileCheckModel(
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
