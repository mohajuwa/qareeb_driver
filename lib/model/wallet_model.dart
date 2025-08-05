// To parse this JSON data, do
//
//     final walletDetailModel = walletDetailModelFromJson(jsonString);

import 'dart:convert';

WalletDetailModel walletDetailModelFromJson(String str) => WalletDetailModel.fromJson(json.decode(str));

String walletDetailModelToJson(WalletDetailModel data) => json.encode(data.toJson());

class WalletDetailModel {
  int responseCode;
  bool result;
  String message;
  double walletAmount;
  double withdrawAmount;
  String minimumWiAmount;
  List<WalletDatum> walletData;

  WalletDetailModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.walletAmount,
    required this.withdrawAmount,
    required this.minimumWiAmount,
    required this.walletData,
  });

  factory WalletDetailModel.fromJson(Map<String, dynamic> json) => WalletDetailModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    walletAmount: json["wallet_amount"]?.toDouble(),
    withdrawAmount: json["Withdraw_amount"]?.toDouble(),
    minimumWiAmount: json["minimum_wi_amount"],
    walletData: List<WalletDatum>.from(json["wallet_data"].map((x) => WalletDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "wallet_amount": walletAmount,
    "Withdraw_amount": withdrawAmount,
    "minimum_wi_amount": minimumWiAmount,
    "wallet_data": List<dynamic>.from(walletData.map((x) => x.toJson())),
  };
}

class WalletDatum {
  String date;
  List<Detail> detail;

  WalletDatum({
    required this.date,
    required this.detail,
  });

  factory WalletDatum.fromJson(Map<String, dynamic> json) => WalletDatum(
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
  String paymentId;
  String amount;
  DateTime date;
  String status;
  String type;
  String pName;
  String platformFee;
  String paidAmount;
  String walletPrice;

  Detail({
    required this.id,
    required this.paymentId,
    required this.amount,
    required this.date,
    required this.status,
    required this.type,
    required this.pName,
    required this.platformFee,
    required this.paidAmount,
    required this.walletPrice,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    paymentId: json["payment_id"],
    amount: json["amount"],
    date: DateTime.parse(json["date"]),
    status: json["status"],
    type: json["type"],
    pName: json["p_name"],
    platformFee: json["platform_fee"],
    paidAmount: json["paid_amount"],
    walletPrice: json["wallet_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "payment_id": paymentId,
    "amount": amount,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "status": status,
    "type": type,
    "p_name": pName,
    "platform_fee": platformFee,
    "paid_amount": paidAmount,
    "wallet_price": walletPrice,
  };
}
