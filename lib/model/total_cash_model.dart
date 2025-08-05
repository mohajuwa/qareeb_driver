import 'dart:convert';

TotalCashModel totalCashModelFromJson(String str) => TotalCashModel.fromJson(json.decode(str));

String totalCashModelToJson(TotalCashModel data) => json.encode(data.toJson());

class TotalCashModel {
  int responseCode;
  bool result;
  String message;
  num totCash;
  List<CashDatum> cashData;

  TotalCashModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.totCash,
    required this.cashData,
  });

  factory TotalCashModel.fromJson(Map<String, dynamic> json) => TotalCashModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    totCash: json["tot_cash"],
    cashData: List<CashDatum>.from(json["cash_data"].map((x) => CashDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "tot_cash": totCash,
    "cash_data": List<dynamic>.from(cashData.map((x) => x.toJson())),
  };
}

class CashDatum {
  String date;
  List<Detail> detail;

  CashDatum({
    required this.date,
    required this.detail,
  });

  factory CashDatum.fromJson(Map<String, dynamic> json) => CashDatum(
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
  String driverId;
  String profImage;
  num amount;
  String date;
  String status;

  Detail({
    required this.id,
    required this.driverId,
    required this.profImage,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    driverId: json["driver_id"],
    profImage: json["prof_image"],
    amount: json["amount"],
    date: json["date"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_id": driverId,
    "prof_image": profImage,
    "amount": amount,
    "date": date,
    "status": status,
  };
}
