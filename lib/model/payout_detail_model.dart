import 'dart:convert';

PayoutDetailModel payoutDetailModelFromJson(String str) => PayoutDetailModel.fromJson(json.decode(str));

String payoutDetailModelToJson(PayoutDetailModel data) => json.encode(data.toJson());

class PayoutDetailModel {
  int responseCode;
  bool result;
  String message;
  num totPayout;
  List<PayoutDatum> payoutData;

  PayoutDetailModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.totPayout,
    required this.payoutData,
  });

  factory PayoutDetailModel.fromJson(Map<String, dynamic> json) => PayoutDetailModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    totPayout: json["tot_payout"],
    payoutData: List<PayoutDatum>.from(json["payout_data"].map((x) => PayoutDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "tot_payout": totPayout,
    "payout_data": List<dynamic>.from(payoutData.map((x) => x.toJson())),
  };
}

class PayoutDatum {
  int id;
  String image;
  String driverId;
  String date;
  num amount;
  String pType;
  String status;
  String upiId;
  String paypalId;
  String bankNo;
  String bankIfsc;
  String bankType;

  PayoutDatum({
    required this.id,
    required this.image,
    required this.driverId,
    required this.date,
    required this.amount,
    required this.pType,
    required this.status,
    required this.upiId,
    required this.paypalId,
    required this.bankNo,
    required this.bankIfsc,
    required this.bankType,
  });

  factory PayoutDatum.fromJson(Map<String, dynamic> json) => PayoutDatum(
    id: json["id"],
    image: json["image"],
    driverId: json["driver_id"],
    date: json["date"],
    amount: json["amount"],
    pType: json["p_type"],
    status: json["status"],
    upiId: json["upi_id"],
    paypalId: json["paypal_id"],
    bankNo: json["bank_no"],
    bankIfsc: json["bank_ifsc"],
    bankType: json["bank_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "driver_id": driverId,
    "date": date,
    "amount": amount,
    "p_type": pType,
    "status": status,
    "upi_id": upiId,
    "paypal_id": paypalId,
    "bank_no": bankNo,
    "bank_ifsc": bankIfsc,
    "bank_type": bankType,
  };
}
