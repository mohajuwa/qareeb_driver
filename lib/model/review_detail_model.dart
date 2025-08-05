// To parse this JSON data, do
//
//     final reviewDetailModel = reviewDetailModelFromJson(jsonString);

import 'dart:convert';

ReviewDetailModel reviewDetailModelFromJson(String str) => ReviewDetailModel.fromJson(json.decode(str));

String reviewDetailModelToJson(ReviewDetailModel data) => json.encode(data.toJson());

class ReviewDetailModel {
  int responseCode;
  bool result;
  String message;
  List<ReviewDatum> reviewData;

  ReviewDetailModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.reviewData,
  });

  factory ReviewDetailModel.fromJson(Map<String, dynamic> json) => ReviewDetailModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    reviewData: List<ReviewDatum>.from(json["review_data"].map((x) => ReviewDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "review_data": List<dynamic>.from(reviewData.map((x) => x.toJson())),
  };
}

class ReviewDatum {
  int id;
  String requestId;
  String review;
  num totStar;
  String date;
  String cusName;
  List<String> defTitle;

  ReviewDatum({
    required this.id,
    required this.requestId,
    required this.review,
    required this.totStar,
    required this.date,
    required this.cusName,
    required this.defTitle,
  });

  factory ReviewDatum.fromJson(Map<String, dynamic> json) => ReviewDatum(
    id: json["id"],
    requestId: json["request_id"],
    review: json["review"],
    totStar: json["tot_star"]?.toDouble(),
    date: json["date"],
    cusName: json["cus_name"],
    defTitle: List<String>.from(json["def_title"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "request_id": requestId,
    "review": review,
    "tot_star": totStar,
    "date": date,
    "cus_name": cusName,
    "def_title": List<dynamic>.from(defTitle.map((x) => x)),
  };
}
