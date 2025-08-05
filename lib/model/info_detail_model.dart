import 'dart:convert';

InfoDetailModel infoDetailModelFromJson(String str) => InfoDetailModel.fromJson(json.decode(str));

String infoDetailModelToJson(InfoDetailModel data) => json.encode(data.toJson());

class InfoDetailModel {
  int responseCode;
  bool result;
  String message;
  List<PreferenceList> zoneData;
  List<PreferenceList> vehicleList;
  List<PreferenceList> preferenceList;
  List<DocumantList> documantList;

  InfoDetailModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.zoneData,
    required this.vehicleList,
    required this.preferenceList,
    required this.documantList,
  });

  factory InfoDetailModel.fromJson(Map<String, dynamic> json) => InfoDetailModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    zoneData: List<PreferenceList>.from(json["zone_data"].map((x) => PreferenceList.fromJson(x))),
    vehicleList: List<PreferenceList>.from(json["vehicle_list"].map((x) => PreferenceList.fromJson(x))),
    preferenceList: List<PreferenceList>.from(json["preference_list"].map((x) => PreferenceList.fromJson(x))),
    documantList: List<DocumantList>.from(json["documant_list"].map((x) => DocumantList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "zone_data": List<dynamic>.from(zoneData.map((x) => x.toJson())),
    "vehicle_list": List<dynamic>.from(vehicleList.map((x) => x.toJson())),
    "preference_list": List<dynamic>.from(preferenceList.map((x) => x.toJson())),
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

  DocumantList({
    required this.id,
    required this.name,
    required this.requireImageSide,
    required this.inputRequire,
    required this.status,
    required this.reqFieldName,
  });

  factory DocumantList.fromJson(Map<String, dynamic> json) => DocumantList(
    id: json["id"],
    name: json["name"],
    requireImageSide: json["require_image_side"],
    inputRequire: json["input_require"],
    status: json["status"],
    reqFieldName: json["req_field_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "require_image_side": requireImageSide,
    "input_require": inputRequire,
    "status": status,
    "req_field_name": reqFieldName,
  };
}

class PreferenceList {
  int id;
  String? image;
  String name;
  String? status;
  String? description;

  PreferenceList({
    required this.id,
    this.image,
    required this.name,
    this.status,
    this.description,
  });

  factory PreferenceList.fromJson(Map<String, dynamic> json) => PreferenceList(
    id: json["id"],
    image: json["image"],
    name: json["name"],
    status: json["status"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "name": name,
    "status": status,
    "description": description,
  };
}
