// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../model/check_vehicle_request_model.dart';
import '../screen/home/sound_player.dart';
import '../widget/common.dart';

class CheckVehicleRequestController extends GetxController
    implements GetxService {
  CheckVehicleRequestModel? checkVehicleRequestModel;

  final NotificationSoundPlayer notificationSoundPlayer =
      NotificationSoundPlayer();
  bool isLoading = false;

  Future checkVehicleApi({required String uid}) async {
    Map body = {"uid": uid};

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };

    var response = await http.post(
        Uri.parse(Config.baseUrl + Config.checkVehicleRequest),
        body: jsonEncode(body),
        headers: userHeader);

    print("+++++++++++++++++ ${body}");
    print("+++++++++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        checkVehicleRequestModel =
            checkVehicleRequestModelFromJson(response.body);
        if (checkVehicleRequestModel!.result == true) {
          notificationSoundPlayer.stopNotificationSound();
          isLoading = true;
          update();
          return response.body;
        } else {
          flutterToast(text: checkVehicleRequestModel!.message.toString());
        }
      } else {
        flutterToast(text: "${data["message"]}");
      }
    } else {
      flutterToast(
          text:
              "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added."
                  .tr);
    }
  }
}
