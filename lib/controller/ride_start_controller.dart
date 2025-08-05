// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/screen/auth_screen/splash_screen.dart';
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/ride_start_model.dart';
import '../widget/common.dart';

class RideStartController extends GetxController implements GetxService {
  RideStartModel? rideStartModel;
  bool isLoading = false;

  bool isLoad = false;
  bool isCircle = false;

  Future rideStartApi({required context, required String requestId}) async {
    if (isLoad) {
      return;
    } else {
      isLoad = true;
    }

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
      Uri.parse(Config.baseUrl + Config.rideStart),
      body: jsonEncode(body),
      headers: userHeader,
    );

    print("+++++++++++++++++ ${body}");
    print("+++++++++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        rideStartModel = rideStartModelFromJson(response.body);
        if (rideStartModel!.result == true) {
          isLoading = true;
          isLoad = false;
          // isCircle = false;
          update();
          return response.body;
        } else {
          snackBar(context: context, text: rideStartModel!.message.toString());
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
