import 'dart:convert';

CommonNotificationModel commonNotificationModelFromJson(String str) => CommonNotificationModel.fromJson(json.decode(str));

String commonNotificationModelToJson(CommonNotificationModel data) => json.encode(data.toJson());

class CommonNotificationModel {
  int responseCode;
  bool result;
  String message;
  List<Ndatum> ndata;

  CommonNotificationModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.ndata,
  });

  factory CommonNotificationModel.fromJson(Map<String, dynamic> json) => CommonNotificationModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    ndata: List<Ndatum>.from(json["ndata"].map((x) => Ndatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "ndata": List<dynamic>.from(ndata.map((x) => x.toJson())),
  };
}

class Ndatum {
  int id;
  String image;
  String title;
  String description;
  String date;

  Ndatum({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.date,
  });

  factory Ndatum.fromJson(Map<String, dynamic> json) => Ndatum(
    id: json["id"],
    image: json["image"],
    title: json["title"],
    description: json["description"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "title": title,
    "description": description,
    "date": date,
  };
}
