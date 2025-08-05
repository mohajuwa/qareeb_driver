
import 'dart:convert';

DocumentStatusModel documentStatusModelFromJson(String str) => DocumentStatusModel.fromJson(json.decode(str));

String documentStatusModelToJson(DocumentStatusModel data) => json.encode(data.toJson());

class DocumentStatusModel {
  int responseCode;
  bool result;
  String message;
  String accountStatus;
  String documentStatus;

  DocumentStatusModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.accountStatus,
    required this.documentStatus,
  });

  factory DocumentStatusModel.fromJson(Map<String, dynamic> json) => DocumentStatusModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    accountStatus: json["account_status"],
    documentStatus: json["document_status"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "account_status": accountStatus,
    "document_status": documentStatus,
  };
}
