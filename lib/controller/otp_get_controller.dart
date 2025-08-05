// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/config/config.dart';
import 'package:qareeb/widget/common.dart';
import '../model/otp_get_model.dart';

class OtpGetController extends GetxController implements GetxService {
  OtpGetModel? otpGetModel;

  Future otpGetApi({required context}) async {
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    var response = await http.get(
      Uri.parse(Config.baseUrl + Config.otpGet),
      headers: userHeader,
    );

    print('${response.body}');

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        otpGetModel = otpGetModelFromJson(response.body);
        if (otpGetModel!.result == true) {
          update();
          return data;
        } else {}
      } else {
        // snackBar(context: context,text: "${data[""]}");
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
