// To parse this JSON data, do
//
//     final verificationCheckModel = verificationCheckModelFromJson(jsonString);

import 'dart:convert';

VerificationCheckModel verificationCheckModelFromJson(String str) => VerificationCheckModel.fromJson(json.decode(str));

String verificationCheckModelToJson(VerificationCheckModel data) => json.encode(data.toJson());

class VerificationCheckModel {
  int responseCode;
  bool result;
  String message;
  String uploadCheck;
  String driverStatus;
  List<DocumantList> documantList;

  VerificationCheckModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.uploadCheck,
    required this.driverStatus,
    required this.documantList,
  });

  factory VerificationCheckModel.fromJson(Map<String, dynamic> json) => VerificationCheckModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    uploadCheck: json["upload_check"],
    driverStatus: json["driver_status"],
    documantList: List<DocumantList>.from(json["documant_list"].map((x) => DocumantList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "upload_check": uploadCheck,
    "driver_status": driverStatus,
    "documant_list": List<dynamic>.from(documantList.map((x) => x.toJson())),
  };
}

class DocumantList {
  int id;
  String name;
  String requireImageSide;
  String inputRequire;
  String status;
  String reqFieldName;
  String approve;

  DocumantList({
    required this.id,
    required this.name,
    required this.requireImageSide,
    required this.inputRequire,
    required this.status,
    required this.reqFieldName,
    required this.approve,
  });

  factory DocumantList.fromJson(Map<String, dynamic> json) => DocumantList(
    id: json["id"],
    name: json["name"],
    requireImageSide: json["require_image_side"],
    inputRequire: json["input_require"],
    status: json["status"],
    reqFieldName: json["req_field_name"],
    approve: json["approve"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "require_image_side": requireImageSide,
    "input_require": inputRequire,
    "status": status,
    "req_field_name": reqFieldName,
    "approve": approve,
  };
}
