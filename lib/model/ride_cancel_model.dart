import 'dart:convert';

RideCancelModel rideCancelModelFromJson(String str) => RideCancelModel.fromJson(json.decode(str));

String rideCancelModelToJson(RideCancelModel data) => json.encode(data.toJson());

class RideCancelModel {
  int responseCode;
  bool result;
  String message;
  String status;
  String rideStatus;
  CurrentAddress currentAddress;
  CurrentAddress nextAddress;
  List<CurrentAddress> dropList;

  RideCancelModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.status,
    required this.rideStatus,
    required this.currentAddress,
    required this.nextAddress,
    required this.dropList,
  });

  factory RideCancelModel.fromJson(Map<String, dynamic> json) => RideCancelModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    status: json["status"],
    rideStatus: json["ride_status"],
    currentAddress: CurrentAddress.fromJson(json["current_address"]),
    nextAddress: CurrentAddress.fromJson(json["next_address"]),
    dropList: List<CurrentAddress>.from(json["drop_list"].map((x) => CurrentAddress.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "status": status,
    "ride_status": rideStatus,
    "current_address": currentAddress.toJson(),
    "next_address": nextAddress.toJson(),
    "drop_list": List<dynamic>.from(dropList.map((x) => x.toJson())),
  };
}

class CurrentAddress {
  String title;
  String subtitle;
  String latitude;
  String longitude;
  String? status;

  CurrentAddress({
    required this.title,
    required this.subtitle,
    required this.latitude,
    required this.longitude,
    this.status,
  });

  factory CurrentAddress.fromJson(Map<String, dynamic> json) => CurrentAddress(
    title: json["title"],
    subtitle: json["subtitle"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "subtitle": subtitle,
    "latitude": latitude,
    "longitude": longitude,
    "status": status,
  };
}
