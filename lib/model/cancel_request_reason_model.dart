import 'dart:convert';

CancelRequestReasonModel cancelRequestReasonModelFromJson(String str) => CancelRequestReasonModel.fromJson(json.decode(str));

String cancelRequestReasonModelToJson(CancelRequestReasonModel data) => json.encode(data.toJson());

class CancelRequestReasonModel {
  int responseCode;
  bool result;
  String message;
  List<RideCancelList> rideCancelList;

  CancelRequestReasonModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.rideCancelList,
  });

  factory CancelRequestReasonModel.fromJson(Map<String, dynamic> json) => CancelRequestReasonModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    rideCancelList: List<RideCancelList>.from(json["ride_cancel_list"].map((x) => RideCancelList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "ride_cancel_list": List<dynamic>.from(rideCancelList.map((x) => x.toJson())),
  };
}

class RideCancelList {
  int id;
  String title;

  RideCancelList({
    required this.id,
    required this.title,
  });

  factory RideCancelList.fromJson(Map<String, dynamic> json) => RideCancelList(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
