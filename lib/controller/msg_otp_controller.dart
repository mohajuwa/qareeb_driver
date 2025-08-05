// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/config/config.dart';
import '../model/msg_otp_model.dart';
import '../widget/common.dart';

class MsgOtpController extends GetxController implements GetxService {
  MsgOtpModel? msgOtpModel;

  Future msgOtpApi({required context, required String phone}) async {
    Map body = {"phoneno": phone};
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    var response = await http.post(
      Uri.parse(Config.baseUrl + Config.msgOtp),
      body: jsonEncode(body),
      headers: userHeader,
    );

    print("msgApi body ${body}");
    print("msgapi repsone ${response.body}");

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        msgOtpModel = msgOtpModelFromJson(response.body);
        if (msgOtpModel!.result == true) {
          update();
          snackBar(context: context, text: "${data["message"]}");
          return response.body;
        } else {
          snackBar(context: context, text: msgOtpModel!.message.toString());
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
