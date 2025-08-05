// To parse this JSON data, do
//
//     final myEarningModel = myEarningModelFromJson(jsonString);

import 'dart:convert';

MyEarningModel myEarningModelFromJson(String str) => MyEarningModel.fromJson(json.decode(str));

String myEarningModelToJson(MyEarningModel data) => json.encode(data.toJson());

class MyEarningModel {
  int responseCode;
  bool result;
  String message;
  Earnings earnings;
  List<RideDatum> rideData;

  MyEarningModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.earnings,
    required this.rideData,
  });

  factory MyEarningModel.fromJson(Map<String, dynamic> json) => MyEarningModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    earnings: Earnings.fromJson(json["earnings"]),
    rideData: List<RideDatum>.from(json["ride_data"].map((x) => RideDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "earnings": earnings.toJson(),
    "ride_data": List<dynamic>.from(rideData.map((x) => x.toJson())),
  };
}

class Earnings {
  num todayTrip;
  num todayPrice;
  num todayMinute;
  num totTrip;
  num totPrice;
  num totMinute;

  Earnings({
    required this.todayTrip,
    required this.todayPrice,
    required this.todayMinute,
    required this.totTrip,
    required this.totPrice,
    required this.totMinute,
  });

  factory Earnings.fromJson(Map<String, dynamic> json) => Earnings(
    todayTrip: json["today_trip"],
    todayPrice: json["today_price"],
    todayMinute: json["today_minute"],
    totTrip: json["tot_trip"],
    totPrice: json["tot_price"],
    totMinute: json["tot_minute"],
  );

  Map<String, dynamic> toJson() => {
    "today_trip": todayTrip,
    "today_price": todayPrice,
    "today_minute": todayMinute,
    "tot_trip": totTrip,
    "tot_price": totPrice,
    "tot_minute": totMinute,
  };
}

class RideDatum {
  int id;
  String dId;
  num finalPrice;
  String totKm;
  num totMinute;
  String startTime;
  Address picAddress;
  Address dropAddress;

  RideDatum({
    required this.id,
    required this.dId,
    required this.finalPrice,
    required this.totKm,
    required this.totMinute,
    required this.startTime,
    required this.picAddress,
    required this.dropAddress,
  });

  factory RideDatum.fromJson(Map<String, dynamic> json) => RideDatum(
    id: json["id"],
    dId: json["d_id"],
    finalPrice: json["final_price"],
    totKm: json["tot_km"],
    totMinute: json["tot_minute"],
    startTime: json["start_time"],
    picAddress: Address.fromJson(json["pic_address"]),
    dropAddress: Address.fromJson(json["drop_address"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "d_id": dId,
    "final_price": finalPrice,
    "tot_km": totKm,
    "tot_minute": totMinute,
    "start_time": startTime,
    "pic_address": picAddress.toJson(),
    "drop_address": dropAddress.toJson(),
  };
}

class Address {
  String title;
  String subtitle;

  Address({
    required this.title,
    required this.subtitle,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    title: json["title"],
    subtitle: json["subtitle"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "subtitle": subtitle,
  };
}
