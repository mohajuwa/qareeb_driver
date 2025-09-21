// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/bottom_navigation_bar.dart';
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/cancel_request_model.dart';
import '../screen/auth_screen/splash_screen.dart';
import '../widget/common.dart';
import 'check_vehicle_request_controller.dart';

class CancelRequestController extends GetxController implements GetxService {
  CancelRequestModel? cancelRequestModel;
  CheckVehicleRequestController checkVehicleRequestController = Get.put(
    CheckVehicleRequestController(),
  );

  Future cancelRequestApi({
    required context,
    required String requestId,
    required String cID,
    String? cancelId,
  }) async {
    Map body = {
      "uid": getData.read("UserLogin")['id'],
      "request_id": requestId,
      "c_id": cID,
      "cancel_id": cancelId,
      "lat": movingLat.toString(),
      "lon": movingLong.toString(),
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    var response = await http.post(
      Uri.parse(Config.baseUrl + Config.cancelRequest),
      body: jsonEncode(body),
      headers: userHeader,
    );

    print("+++++++++++++++++ ${body}");
    print("+++++++++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        cancelRequestModel = cancelRequestModelFromJson(response.body);
        if (cancelRequestModel!.result == true) {
          currentIndexBottom = 0;
          Get.offAll(const BottomBarScreen());
          checkVehicleRequestController.checkVehicleApi(
            uid: getData.read("UserLogin")["id"].toString(),
          );
          update();
          return response.body;
        } else {
          snackBar(
            context: context,
            text: cancelRequestModel!.message.toString(),
          );
        }
      } else {
        snackBar(context: context, text: "${data["message"]}");
      }
    } else {
      snackBar(
        context: context,
        text:
            "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added."
                .tr,
      );
    }
  }
}
