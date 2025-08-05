import 'dart:convert';

RideHistoryDetailModel rideHistoryDetailModelFromJson(String str) => RideHistoryDetailModel.fromJson(json.decode(str));

String rideHistoryDetailModelToJson(RideHistoryDetailModel data) => json.encode(data.toJson());

class RideHistoryDetailModel {
  int responseCode;
  bool result;
  String message;
  HistoryData historyData;

  RideHistoryDetailModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.historyData,
  });

  factory RideHistoryDetailModel.fromJson(Map<String, dynamic> json) => RideHistoryDetailModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    historyData: HistoryData.fromJson(json["history_data"]),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "history_data": historyData.toJson(),
  };
}

class HistoryData {
  int id;
  String cId;
  String dId;
  String status;
  String cusName;
  String vehicleName;
  num price;
  num finalPrice;
  String totKm;
  num totMinute;
  String startTime;
  num reviewCheck;
  Address picAddress;
  List<Address> dropAddress;
  List<ReviewList> reviewList;

  HistoryData({
    required this.id,
    required this.cId,
    required this.dId,
    required this.status,
    required this.cusName,
    required this.vehicleName,
    required this.price,
    required this.finalPrice,
    required this.totKm,
    required this.totMinute,
    required this.startTime,
    required this.reviewCheck,
    required this.picAddress,
    required this.dropAddress,
    required this.reviewList,
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) => HistoryData(
    id: json["id"],
    cId: json["c_id"],
    dId: json["d_id"],
    status: json["status"],
    cusName: json["cus_name"],
    vehicleName: json["vehicle_name"],
    price: json["price"],
    finalPrice: json["final_price"],
    totKm: json["tot_km"],
    totMinute: json["tot_minute"]?.toDouble(),
    startTime: json["start_time"],
    reviewCheck: json["review_check"],
    picAddress: Address.fromJson(json["pic_address"]),
    dropAddress: List<Address>.from(json["drop_address"].map((x) => Address.fromJson(x))),
    reviewList: List<ReviewList>.from(json["review_list"].map((x) => ReviewList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "c_id": cId,
    "d_id": dId,
    "status": status,
    "cus_name": cusName,
    "vehicle_name": vehicleName,
    "price": price,
    "final_price": finalPrice,
    "tot_km": totKm,
    "tot_minute": totMinute,
    "start_time": startTime,
    "review_check": reviewCheck,
    "pic_address": picAddress.toJson(),
    "drop_address": List<dynamic>.from(dropAddress.map((x) => x.toJson())),
    "review_list": List<dynamic>.from(reviewList.map((x) => x.toJson())),
  };
}

class Address {
  String title;
  String subtitle;
  String time;

  Address({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    title: json["title"],
    subtitle: json["subtitle"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "subtitle": subtitle,
    "time": time,
  };
}

class ReviewList {
  int id;
  String title;
  String status;

  ReviewList({
    required this.id,
    required this.title,
    required this.status,
  });

  factory ReviewList.fromJson(Map<String, dynamic> json) => ReviewList(
    id: json["id"],
    title: json["title"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "status": status,
  };
}
