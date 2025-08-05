import 'dart:convert';

UpdateLocationModel updateLocationModelFromJson(String str) => UpdateLocationModel.fromJson(json.decode(str));

String updateLocationModelToJson(UpdateLocationModel data) => json.encode(data.toJson());

class UpdateLocationModel {
  int responseCode;
  bool result;
  String message;

  UpdateLocationModel({
    required this.responseCode,
    required this.result,
    required this.message,
  });

  factory UpdateLocationModel.fromJson(Map<String, dynamic> json) => UpdateLocationModel(
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
