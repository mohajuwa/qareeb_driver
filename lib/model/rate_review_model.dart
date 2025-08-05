import 'dart:convert';

RateAndReviewModel rateAndReviewModelFromJson(String str) => RateAndReviewModel.fromJson(json.decode(str));

String rateAndReviewModelToJson(RateAndReviewModel data) => json.encode(data.toJson());

class RateAndReviewModel {
  int responseCode;
  bool result;
  String message;

  RateAndReviewModel({
    required this.responseCode,
    required this.result,
    required this.message,
  });

  factory RateAndReviewModel.fromJson(Map<String, dynamic> json) => RateAndReviewModel(
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
