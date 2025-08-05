// ignore_for_file: unused_import, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/screen/auth_screen/splash_screen.dart';
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/accept_request_model.dart';
import '../model/request_detail_model.dart';
import '../screen/home/sound_player.dart';
import '../widget/common.dart';

class AcceptRequestController extends GetxController implements GetxService {
  final NotificationSoundPlayer notificationSoundPlayer =
      NotificationSoundPlayer();

  AcceptRequestModel? acceptRequestModel;
  bool isRequestAccepted = false;

  bool get isRequestAccepted1 => isRequestAccepted;

  void acceptRequest({required bool accepted}) {
    isRequestAccepted = accepted;
    update();
  }

  Future acceptRequestApi({required context, required String requestId}) async {
    Map body = {
      "uid": getData.read("UserLogin")['id'],
      "request_id": requestId,
      "lat": movingLat.toString(),
      "lon": movingLong.toString(),
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    var response = await http.post(
      Uri.parse(Config.baseUrl + Config.acceptRequest),
      body: jsonEncode(body),
      headers: userHeader,
    );

    print("+++++++++++++++++ ${body}");
    print("+++++++++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        acceptRequestModel = acceptRequestModelFromJson(response.body);
        if (acceptRequestModel!.result == true) {
          isRequestAccepted = true;
          notificationSoundPlayer.stopNotificationSound();
          update();
          return response.body;
        } else {
          snackBar(
            context: context,
            text: acceptRequestModel!.message.toString(),
          );
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
