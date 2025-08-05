import 'dart:convert';

CompletePriceModel completePriceModelFromJson(String str) => CompletePriceModel.fromJson(json.decode(str));

String completePriceModelToJson(CompletePriceModel data) => json.encode(data.toJson());

class CompletePriceModel {
  int responseCode;
  bool result;
  String message;
  PriceList priceList;
  PaymentData paymentData;
  List<AddCalculate> addCalculate;
  List<ReviewList> reviewList;

  CompletePriceModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.priceList,
    required this.paymentData,
    required this.addCalculate,
    required this.reviewList,
  });

  factory CompletePriceModel.fromJson(Map<String, dynamic> json) => CompletePriceModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    priceList: PriceList.fromJson(json["price_list"]),
    paymentData: PaymentData.fromJson(json["payment_data"]),
    addCalculate: List<AddCalculate>.from(json["add_calculate"].map((x) => AddCalculate.fromJson(x))),
    reviewList: List<ReviewList>.from(json["review_list"].map((x) => ReviewList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "price_list": priceList.toJson(),
    "payment_data": paymentData.toJson(),
    "add_calculate": List<dynamic>.from(addCalculate.map((x) => x.toJson())),
    "review_list": List<dynamic>.from(reviewList.map((x) => x.toJson())),
  };
}

class AddCalculate {
  String title;
  String subtitle;
  String date;
  String totKm;
  String totTime;

  AddCalculate({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.totKm,
    required this.totTime,
  });

  factory AddCalculate.fromJson(Map<String, dynamic> json) => AddCalculate(
    title: json["title"],
    subtitle: json["subtitle"],
    date: json["date"],
    totKm: json["tot_km"],
    totTime: json["tot_time"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "subtitle": subtitle,
    "date": date,
    "tot_km": totKm,
    "tot_time": totTime,
  };
}

class PaymentData {
  int id;
  String image;
  String name;

  PaymentData({
    required this.id,
    required this.image,
    required this.name,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
    id: json["id"],
    image: json["image"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "name": name,
  };
}

class PriceList {
  String cusName;
  num totPrice;
  num finalPrice;
  num couponAmount;
  num addiTimePrice;
  num platformFee;
  num weatherPrice;

  PriceList({
    required this.cusName,
    required this.totPrice,
    required this.finalPrice,
    required this.couponAmount,
    required this.addiTimePrice,
    required this.platformFee,
    required this.weatherPrice,
  });

  factory PriceList.fromJson(Map<String, dynamic> json) => PriceList(
    cusName: json["cus_name"],
    totPrice: json["tot_price"],
    finalPrice: json["final_price"]?.toDouble(),
    couponAmount: json["coupon_amount"],
    addiTimePrice: json["addi_time_price"],
    platformFee: json["platform_fee"],
    weatherPrice: json["weather_price"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "cus_name": cusName,
    "tot_price": totPrice,
    "final_price": finalPrice,
    "coupon_amount": couponAmount,
    "addi_time_price": addiTimePrice,
    "platform_fee": platformFee,
    "weather_price": weatherPrice,
  };
}

class ReviewList {
  int id;
  String title;
  String status;

  ReviewList({
    required this.id,
    required this.title,
    required this.status,
  });

  factory ReviewList.fromJson(Map<String, dynamic> json) => ReviewList(
    id: json["id"],
    title: json["title"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "status": status,
  };
}
