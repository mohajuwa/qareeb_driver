import 'dart:convert';

RideHistoryModel rideHistoryModelFromJson(String str) => RideHistoryModel.fromJson(json.decode(str));

String rideHistoryModelToJson(RideHistoryModel data) => json.encode(data.toJson());

class RideHistoryModel {
  int responseCode;
  bool result;
  String message;
  List<RideDatum> rideData;

  RideHistoryModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.rideData,
  });

  factory RideHistoryModel.fromJson(Map<String, dynamic> json) => RideHistoryModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    rideData: List<RideDatum>.from(json["ride_data"].map((x) => RideDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "ride_data": List<dynamic>.from(rideData.map((x) => x.toJson())),
  };
}

class RideDatum {
  String date;
  List<Detail> detail;

  RideDatum({
    required this.date,
    required this.detail,
  });

  factory RideDatum.fromJson(Map<String, dynamic> json) => RideDatum(
    date: json["date"],
    detail: List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
  };
}

class Detail {
  int id;
  String dId;
  String cusName;
  String vehicleName;
  num finalPrice;
  String totKm;
  num totMinute;
  String startTime;
  Address picAddress;
  Address dropAddress;
  DateTime date;

  Detail({
    required this.id,
    required this.dId,
    required this.cusName,
    required this.vehicleName,
    required this.finalPrice,
    required this.totKm,
    required this.totMinute,
    required this.startTime,
    required this.picAddress,
    required this.dropAddress,
    required this.date,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    dId: json["d_id"],
    cusName: json["cus_name"],
    vehicleName: json["vehicle_name"],
    finalPrice: json["final_price"],
    totKm: json["tot_km"],
    totMinute: json["tot_minute"]?.toDouble(),
    startTime: json["start_time"],
    picAddress: Address.fromJson(json["pic_address"]),
    dropAddress: Address.fromJson(json["drop_address"]),
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "d_id": dId,
    "cus_name": cusName,
    "vehicle_name": vehicleName,
    "final_price": finalPrice,
    "tot_km": totKm,
    "tot_minute": totMinute,
    "start_time": startTime,
    "pic_address": picAddress.toJson(),
    "drop_address": dropAddress.toJson(),
    "date": date.toIso8601String(),
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
