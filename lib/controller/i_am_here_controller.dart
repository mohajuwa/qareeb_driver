// ignore_for_file: unused_import, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/config/config.dart';
import 'package:qareeb/screen/auth_screen/splash_screen.dart';
import '../config/data_store.dart';
import '../model/i_am_here_model.dart';
import '../utils/colors.dart';
import '../utils/font_family.dart';
import '../widget/common.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class IAmHereController extends GetxController implements GetxService {
  IAmHereModel? iAmHereModel;

  bool isLoad = false;
  bool isCircle = false;

  Future iAmHereApi({required context, required String requestID}) async {
    if (isLoad) {
      return;
    } else {
      isLoad = true;
    }
    // isLoading = false;

    Map body = {
      "uid": getData.read("UserLogin")["id"].toString(),
      "request_id": requestID,
      "lat": movingLat.toString(),
      "lon": movingLong.toString(),
    };
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    var response = await http.post(
      Uri.parse(Config.baseUrl + Config.iAmHere),
      body: jsonEncode(body),
      headers: userHeader,
    );

    print("iAmHereApi body ${body}");
    print("iAmHereApi repsone ${response.body}");

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        iAmHereModel = iAmHereModelFromJson(response.body);
        if (iAmHereModel!.result == true) {
          isLoad = false;
          update();
          // snackBar(context: context, text: "${data["message"]}");
          return response.body;
        } else {
          snackBar(context: context, text: iAmHereModel!.message.toString());
        }
      } else {
        snackBar(context: context, text: "${data["message"]}");
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
