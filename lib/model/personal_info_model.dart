import 'dart:convert';

PersonalInfoModel personalInfoModelFromJson(String str) => PersonalInfoModel.fromJson(json.decode(str));

String personalInfoModelToJson(PersonalInfoModel data) => json.encode(data.toJson());

class PersonalInfoModel {
  int responseCode;
  bool result;
  String message;
  DriverData driverData;

  PersonalInfoModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.driverData,
  });

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) => PersonalInfoModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    driverData: DriverData.fromJson(json["driver_data"]),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "driver_data": driverData.toJson(),
  };
}

class DriverData {
  int id;
  String profileImage;
  String firstName;
  String lastName;
  String email;
  String primaryCcode;
  String primaryPhoneNo;
  String secoundCcode;
  String secoundPhoneNo;
  String password;
  String nationality;
  DateTime dateOfBirth;
  String comAddress;
  String zone;
  String language;
  String vehicleImage;
  String vehicle;
  String vehicleNumber;
  String carColor;
  String passengerCapacity;
  String vehiclePrefrence;
  String ibanNumber;
  String bankName;
  String accountHolName;
  String vatId;
  String status;
  String approvalStatus;

  DriverData({
    required this.id,
    required this.profileImage,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.primaryCcode,
    required this.primaryPhoneNo,
    required this.secoundCcode,
    required this.secoundPhoneNo,
    required this.password,
    required this.nationality,
    required this.dateOfBirth,
    required this.comAddress,
    required this.zone,
    required this.language,
    required this.vehicleImage,
    required this.vehicle,
    required this.vehicleNumber,
    required this.carColor,
    required this.passengerCapacity,
    required this.vehiclePrefrence,
    required this.ibanNumber,
    required this.bankName,
    required this.accountHolName,
    required this.vatId,
    required this.status,
    required this.approvalStatus,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) => DriverData(
    id: json["id"],
    profileImage: json["profile_image"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    primaryCcode: json["primary_ccode"],
    primaryPhoneNo: json["primary_phoneNo"],
    secoundCcode: json["secound_ccode"],
    secoundPhoneNo: json["secound_phoneNo"],
    password: json["password"],
    nationality: json["nationality"],
    dateOfBirth: DateTime.parse(json["date_of_birth"]),
    comAddress: json["com_address"],
    zone: json["zone"],
    language: json["language"],
    vehicleImage: json["vehicle_image"],
    vehicle: json["vehicle"],
    vehicleNumber: json["vehicle_number"],
    carColor: json["car_color"],
    passengerCapacity: json["passenger_capacity"],
    vehiclePrefrence: json["vehicle_prefrence"],
    ibanNumber: json["iban_number"],
    bankName: json["bank_name"],
    accountHolName: json["account_hol_name"],
    vatId: json["vat_id"],
    status: json["status"],
    approvalStatus: json["approval_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "profile_image": profileImage,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "primary_ccode": primaryCcode,
    "primary_phoneNo": primaryPhoneNo,
    "secound_ccode": secoundCcode,
    "secound_phoneNo": secoundPhoneNo,
    "password": password,
    "nationality": nationality,
    "date_of_birth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "com_address": comAddress,
    "zone": zone,
    "language": language,
    "vehicle_image": vehicleImage,
    "vehicle": vehicle,
    "vehicle_number": vehicleNumber,
    "car_color": carColor,
    "passenger_capacity": passengerCapacity,
    "vehicle_prefrence": vehiclePrefrence,
    "iban_number": ibanNumber,
    "bank_name": bankName,
    "account_hol_name": accountHolName,
    "vat_id": vatId,
    "status": status,
    "approval_status": approvalStatus,
  };
}
