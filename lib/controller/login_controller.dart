// ignore_for_file: unused_import, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/config/config.dart';
import 'package:qareeb/config/data_store.dart';
import 'package:qareeb/main.dart';
import 'package:qareeb/screen/auth_screen/otp_screen.dart';
import 'package:qareeb/screen/home/home_screen.dart';
import 'package:qareeb/widget/common.dart';
import '../model/login_model.dart';
import '../screen/auth_screen/splash_screen.dart';

class LoginController extends GetxController implements GetxService {
  String ccode = "";
  bool check = false;
  bool mobileCheck = false;
  bool obscureText = true;
  bool isLoading = true;

  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  OtpFieldController otpController = OtpFieldController();
  String otpCode = "";

  checkTermsAndCondition(bool? newBool) {
    check = newBool ?? false;
    update();
  }

  double sliderValue = 0.0;

  LoginModel? loginModel;

  Future loginApi({
    required context,
    required String cCode,
    required String phone,
    required String password,
  }) async {
    Map body = {"ccode": cCode, "phone": phone, "password": password};

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    var response = await http.post(
      Uri.parse(Config.baseUrl + Config.login),
      body: jsonEncode(body),
      headers: userHeader,
    );

    print("1111111 ${body}");
    print(Config.baseUrl + Config.login);
    print("111111111111 ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        loginModel = loginModelFromJson(response.body);
        if (loginModel!.result == true) {
          save("UserLogin", data["driver_data"]);
          save("Currency", data["general"]["site_currency"]);
          save("OneSignal", data["general"]["one_app_id"]);
          log(
            "++++++++++++++++++++++++++++++++++++++++ ${getData.read("UserLogin")["id"]}",
          );
          log(
            "++++++++++++++++++++++++++++++++++++++++ ${getData.read("Currency")}",
          );
          Config.oneSignal = "${getData.read("OneSignal")}";
          initPlatformState();
          OneSignal.User.addTags({
            "subscription_user_Type": 'driver',
            "Login_ID": getData.read("UserLogin")["id"].toString(),
          });
          snackBar(context: context, text: data["message"]);
          mobileCheck = true;
          loginSharedPreferencesSet(false);
          isLoading = false;
          update();
          return response.body;
        } else {
          print("PRATIK 1");
          save("UserLogin", data["driver_data"]);
          save("Currency", data["general"]["site_currency"]);
          save("OneSignal", data["general"]["one_app_id"]);
          isLoading = false;
          snackBar(context: context, text: loginModel!.message);
          update();
          return response.body;
        }
      } else {
        print("PRATIK 2");
        save("UserLogin", data["driver_data"]);
        save("Currency", data["general"]["site_currency"]);
        save("OneSignal", data["general"]["one_app_id"]);
        isLoading = false;
        snackBar(context: context, text: data["message"]);
        update();
        return response.body;
      }
    } else {
      snackBar(
        context: context,
        text:
            "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",
      );
    }
  }
}
