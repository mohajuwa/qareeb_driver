// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/bottom_navigation_bar.dart';
import 'package:qareeb/config/config.dart';
import '../config/data_store.dart';
import '../model/complete_price_model.dart';
import '../widget/common.dart';

class CompletePriceController extends GetxController implements GetxService {
  CompletePriceModel? completePriceModel;
  bool isLoading = false;

  Future priceDetailAPi({
    required context,
    required String requestId,
    required String cID,
  }) async {
    Map body = {
      "uid": getData.read("UserLogin")['id'],
      "request_id": requestId,
      "c_id": cID,
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    var response = await http.post(
      Uri.parse(Config.baseUrl + Config.priceDetail),
      body: jsonEncode(body),
      headers: userHeader,
    );

    print("+++++++priceDetailAPi++++++++++ ${body}");
    print("+++++++priceDetailAPi++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        completePriceModel = completePriceModelFromJson(response.body);
        if (completePriceModel!.result == true) {
          isLoading = true;
          update();
          return response.body;
        } else {
          // snackBar(context: context, text: completePriceModel!.message.toString());
          currentIndexBottom = 0;
          Get.offAll(const BottomBarScreen());
          update();
        }
      } else {
        // snackBar(context: context, text: "${data["message"]}");
        currentIndexBottom = 0;
        Get.offAll(const BottomBarScreen());
        update();
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
