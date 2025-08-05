import 'dart:convert';

PayoutWalletModel payoutWalletModelFromJson(String str) => PayoutWalletModel.fromJson(json.decode(str));

String payoutWalletModelToJson(PayoutWalletModel data) => json.encode(data.toJson());

class PayoutWalletModel {
  int responseCode;
  bool result;
  String message;

  PayoutWalletModel({
    required this.responseCode,
    required this.result,
    required this.message,
  });

  factory PayoutWalletModel.fromJson(Map<String, dynamic> json) => PayoutWalletModel(
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
