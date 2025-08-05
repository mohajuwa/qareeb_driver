import 'dart:convert';

LiveStatusModel liveStatusModelFromJson(String str) => LiveStatusModel.fromJson(json.decode(str));

String liveStatusModelToJson(LiveStatusModel data) => json.encode(data.toJson());

class LiveStatusModel {
  int responseCode;
  bool result;
  String message;

  LiveStatusModel({
    required this.responseCode,
    required this.result,
    required this.message,
  });

  factory LiveStatusModel.fromJson(Map<String, dynamic> json) => LiveStatusModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
  };
}
