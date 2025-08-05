import 'dart:convert';

CashDetailModel cashDetailModelFromJson(String str) => CashDetailModel.fromJson(json.decode(str));

String cashDetailModelToJson(CashDetailModel data) => json.encode(data.toJson());

class CashDetailModel {
  int responseCode;
  bool result;
  String message;
  num totCashAmount;
  List<WalletDatum> walletData;

  CashDetailModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.totCashAmount,
    required this.walletData,
  });

  factory CashDetailModel.fromJson(Map<String, dynamic> json) => CashDetailModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    totCashAmount: json["tot_cash_amount"]?.toDouble(),
    walletData: List<WalletDatum>.from(json["wallet_data"].map((x) => WalletDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "tot_cash_amount": totCashAmount,
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
  String date;
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
    date: json["date"],
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
    "date": date,
    "status": status,
    "type": type,
    "p_name": pName,
    "platform_fee": platformFee,
    "paid_amount": paidAmount,
    "wallet_price": walletPrice,
  };
}
