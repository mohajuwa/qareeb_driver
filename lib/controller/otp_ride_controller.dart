// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/otp_ride_model.dart';
import '../screen/auth_screen/splash_screen.dart';
import '../widget/common.dart';

class OtpRideController extends GetxController implements GetxService {

  OtpRideModel? otpRideModel;

  bool isLoad = false;
  bool isCircle = false;

  TextEditingController otpController = TextEditingController();
  // bool isLoading = false;

  Future otpRideApi({required context,required String requestId, required String otp,required String time}) async{

    if(isLoad){
      return;
    }else{
      isLoad = true;
    }

    Map body = {
      "uid": getData.read("UserLogin")['id'],
      "request_id": requestId,
      "otp": otp,
      "lat": movingLat.toString(),
      "lon": movingLong.toString(),
      "time": time
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    var response = await http.post(Uri.parse(Config.baseUrl + Config.otpRide),body: jsonEncode(body),headers: userHeader);

    print("++++++otpRideApi+++++++++++ ${body}");
    print("++++++otpRideApi+++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        otpRideModel = otpRideModelFromJson(response.body);
        if (otpRideModel!.result == true) {
          // isLoading = true;
          // Get.back();
          isLoad = false;
          // isCircle = false;
          update();
          return response.body;

        } else {
          flutterToast(text: otpRideModel!.message.toString());
        }
      } else {
        flutterToast(text: "${data["message"]}");
      }
    } else {
      flutterToast(text: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }

  }
}