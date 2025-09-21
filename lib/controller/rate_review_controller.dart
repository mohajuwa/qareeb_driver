import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/config/config.dart';
import '../bottom_navigation_bar.dart';
import '../config/data_store.dart';
import '../model/rate_review_model.dart';
import '../widget/common.dart';

class RateReviewController extends GetxController implements GetxService {
  RateAndReviewModel? rateAndReviewModel;
  bool isLoading = false;

  double tRate = 1.0;
  totalRateUpdate(double rating) {
    tRate = rating;
    update();
  }

  TextEditingController reviewController = TextEditingController();
  List reviewList = [];

  Future rateReviewAPi({
    required context,
    required String requestId,
    required String cID,
  }) async {
    Map body = {
      "uid": getData.read("UserLogin")['id'],
      "request_id": requestId,
      "c_id": cID,
      "def_review": reviewList,
      "review": reviewController.text,
      "tot_star": tRate,
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    var response = await http.post(
      Uri.parse(Config.baseUrl + Config.rateReview),
      body: jsonEncode(body),
      headers: userHeader,
    );

    print("+++++++rateReviewAPi++++++++++ $body");
    print("+++++++rateReviewAPi++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        rateAndReviewModel = rateAndReviewModelFromJson(response.body);
        if (rateAndReviewModel!.result == true) {
          isLoading = true;
          currentIndexBottom = 0;
          Get.offAll(const BottomBarScreen());
          update();
          snackBar(context: context, text: "${data["message"]}");
          return response.body;
        } else {
          snackBar(
            context: context,
            text: rateAndReviewModel!.message.toString(),
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
