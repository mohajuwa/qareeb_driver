// import 'dart:convert';
//
// CheckVehicleRequestModel checkVehicleRequestModelFromJson(String str) => CheckVehicleRequestModel.fromJson(json.decode(str));
//
// String checkVehicleRequestModelToJson(CheckVehicleRequestModel data) => json.encode(data.toJson());
//
// class CheckVehicleRequestModel {
//   int responseCode;
//   bool result;
//   String message;
//   General general;
//   List<RequestDatum> requestData;
//
//   CheckVehicleRequestModel({
//     required this.responseCode,
//     required this.result,
//     required this.message,
//     required this.general,
//     required this.requestData,
//   });
//
//   factory CheckVehicleRequestModel.fromJson(Map<String, dynamic> json) => CheckVehicleRequestModel(
//     responseCode: json["ResponseCode"],
//     result: json["Result"],
//     message: json["message"],
//     general: General.fromJson(json["general"]),
//     requestData: List<RequestDatum>.from(json["request_data"].map((x) => RequestDatum.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "ResponseCode": responseCode,
//     "Result": result,
//     "message": message,
//     "general": general.toJson(),
//     "request_data": List<dynamic>.from(requestData.map((x) => x.toJson())),
//   };
// }
//
// class General {
//   String alertTone;
//
//   General({
//     required this.alertTone,
//   });
//
//   factory General.fromJson(Map<String, dynamic> json) => General(
//     alertTone: json["alert_tone"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "alert_tone": alertTone,
//   };
// }
//
// class RequestDatum {
//   int id;
//   String cId;
//   String name;
//   num rating;
//   int review;
//   String price;
//   String perKmPrice;
//   String totKm;
//   int totHour;
//   int totMinute;
//   String status;
//   RunningTime runningTime;
//   Latlon pickLatlon;
//   List<Latlon> dropLatlon;
//   Add pickAdd;
//   List<Add> dropAdd;
//
//   RequestDatum({
//     required this.id,
//     required this.cId,
//     required this.name,
//     required this.rating,
//     required this.review,
//     required this.price,
//     required this.perKmPrice,
//     required this.totKm,
//     required this.totHour,
//     required this.totMinute,
//     required this.status,
//     required this.runningTime,
//     required this.pickLatlon,
//     required this.dropLatlon,
//     required this.pickAdd,
//     required this.dropAdd,
//   });
//
//   factory RequestDatum.fromJson(Map<String, dynamic> json) => RequestDatum(
//     id: json["id"],
//     cId: json["c_id"],
//     name: json["name"],
//     rating: json["rating"],
//     review: json["review"],
//     price: json["price"],
//     perKmPrice: json["per_km_price"],
//     totKm: json["tot_km"],
//     totHour: json["tot_hour"],
//     totMinute: json["tot_minute"],
//     status: json["status"],
//     runningTime: RunningTime.fromJson(json["running_time"]),
//     pickLatlon: Latlon.fromJson(json["pick_latlon"]),
//     dropLatlon: List<Latlon>.from(json["drop_latlon"].map((x) => Latlon.fromJson(x))),
//     pickAdd: Add.fromJson(json["pick_add"]),
//     dropAdd: List<Add>.from(json["drop_add"].map((x) => Add.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "c_id": cId,
//     "name": name,
//     "rating": rating,
//     "review": review,
//     "price": price,
//     "per_km_price": perKmPrice,
//     "tot_km": totKm,
//     "tot_hour": totHour,
//     "tot_minute": totMinute,
//     "status": status,
//     "running_time": runningTime.toJson(),
//     "pick_latlon": pickLatlon.toJson(),
//     "drop_latlon": List<dynamic>.from(dropLatlon.map((x) => x.toJson())),
//     "pick_add": pickAdd.toJson(),
//     "drop_add": List<dynamic>.from(dropAdd.map((x) => x.toJson())),
//   };
// }
//
// class Add {
//   String title;
//   String subtitle;
//
//   Add({
//     required this.title,
//     required this.subtitle,
//   });
//
//   factory Add.fromJson(Map<String, dynamic> json) => Add(
//     title: json["title"],
//     subtitle: json["subtitle"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "title": title,
//     "subtitle": subtitle,
//   };
// }
//
// class Latlon {
//   String latitude;
//   String longitude;
//
//   Latlon({
//     required this.latitude,
//     required this.longitude,
//   });
//
//   factory Latlon.fromJson(Map<String, dynamic> json) => Latlon(
//     latitude: json["latitude"],
//     longitude: json["longitude"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "latitude": latitude,
//     "longitude": longitude,
//   };
// }
//
// class RunningTime {
//   int runTime;
//   int status;
//
//   RunningTime({
//     required this.runTime,
//     required this.status,
//   });
//
//   factory RunningTime.fromJson(Map<String, dynamic> json) => RunningTime(
//     runTime: json["run_time"],
//     status: json["status"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "run_time": runTime,
//     "status": status,
//   };
// }
//
//
//

import 'dart:convert';

CheckVehicleRequestModel checkVehicleRequestModelFromJson(String str) => CheckVehicleRequestModel.fromJson(json.decode(str));

String checkVehicleRequestModelToJson(CheckVehicleRequestModel data) => json.encode(data.toJson());

class CheckVehicleRequestModel {
  int responseCode;
  bool result;
  String message;
  General general;
  List<RequestDatum> requestData;

  CheckVehicleRequestModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.general,
    required this.requestData,
  });

  factory CheckVehicleRequestModel.fromJson(Map<String, dynamic> json) => CheckVehicleRequestModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    general: General.fromJson(json["general"]),
    requestData: List<RequestDatum>.from(json["request_data"].map((x) => RequestDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "general": general.toJson(),
    "request_data": List<dynamic>.from(requestData.map((x) => x.toJson())),
  };
}

class General {
  String alertTone;

  General({
    required this.alertTone,
  });

  factory General.fromJson(Map<String, dynamic> json) => General(
    alertTone: json["alert_tone"],
  );

  Map<String, dynamic> toJson() => {
    "alert_tone": alertTone,
  };
}

class RequestDatum {
  int id;
  String cId;
  String name;
  num rating;
  num review;
  num price;
  String perKmPrice;
  String totKm;
  num totHour;
  num totMinute;
  String status;
  String biddingStatus;
  String biddAutoStatus;
  num biddExTime;
  List<num> driOfferLimite;
  RunningTime runningTime;
  Latlon pickLatlon;
  List<Latlon> dropLatlon;
  Add pickAdd;
  List<Add> dropAdd;

  // int id;
//   String cId;
//   String name;
//   num rating;
//   int review;
//   String price;
//   String perKmPrice;
//   String totKm;
//   int totHour;
//   int totMinute;
//   String status;
//   RunningTime runningTime;
//   Latlon pickLatlon;
//   List<Latlon> dropLatlon;
//   Add pickAdd;
//   List<Add> dropAdd;

  RequestDatum({
    required this.id,
    required this.cId,
    required this.name,
    required this.rating,
    required this.review,
    required this.price,
    required this.perKmPrice,
    required this.totKm,
    required this.totHour,
    required this.totMinute,
    required this.status,
    required this.biddingStatus,
    required this.biddAutoStatus,
    required this.biddExTime,
    required this.driOfferLimite,
    required this.runningTime,
    required this.pickLatlon,
    required this.dropLatlon,
    required this.pickAdd,
    required this.dropAdd,
  });

  factory RequestDatum.fromJson(Map<String, dynamic> json) => RequestDatum(
    id: json["id"],
    cId: json["c_id"],
    name: json["name"],
    rating: json["rating"]?.toDouble(),
    review: json["review"],
    price: json["price"],
    perKmPrice: json["per_km_price"],
    totKm: json["tot_km"],
    totHour: json["tot_hour"],
    totMinute: json["tot_minute"],
    status: json["status"],
    biddingStatus: json["bidding_status"],
    biddAutoStatus: json["bidd_auto_status"],
    biddExTime: json["bidd_ex_time"],
    driOfferLimite: List<num>.from(json["dri_offer_limite"].map((x) => x)),
    runningTime: RunningTime.fromJson(json["running_time"]),
    pickLatlon: Latlon.fromJson(json["pick_latlon"]),
    dropLatlon: List<Latlon>.from(json["drop_latlon"].map((x) => Latlon.fromJson(x))),
    pickAdd: Add.fromJson(json["pick_add"]),
    dropAdd: List<Add>.from(json["drop_add"].map((x) => Add.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "c_id": cId,
    "name": name,
    "rating": rating,
    "review": review,
    "price": price,
    "per_km_price": perKmPrice,
    "tot_km": totKm,
    "tot_hour": totHour,
    "tot_minute": totMinute,
    "status": status,
    "bidding_status": biddingStatus,
    "bidd_auto_status": biddAutoStatus,
    "bidd_ex_time": biddExTime,
    "dri_offer_limite": List<dynamic>.from(driOfferLimite.map((x) => x)),
    "running_time": runningTime.toJson(),
    "pick_latlon": pickLatlon.toJson(),
    "drop_latlon": List<dynamic>.from(dropLatlon.map((x) => x.toJson())),
    "pick_add": pickAdd.toJson(),
    "drop_add": List<dynamic>.from(dropAdd.map((x) => x.toJson())),
  };
}

class Add {
  String title;
  String subtitle;

  Add({
    required this.title,
    required this.subtitle,
  });

  factory Add.fromJson(Map<String, dynamic> json) => Add(
    title: json["title"],
    subtitle: json["subtitle"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "subtitle": subtitle,
  };
}

class Latlon {
  String latitude;
  String longitude;

  Latlon({
    required this.latitude,
    required this.longitude,
  });

  factory Latlon.fromJson(Map<String, dynamic> json) => Latlon(
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class RunningTime {
  int runTime;
  int status;

  RunningTime({
    required this.runTime,
    required this.status,
  });

  factory RunningTime.fromJson(Map<String, dynamic> json) => RunningTime(
    runTime: json["run_time"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "run_time": runTime,
    "status": status,
  };
}
