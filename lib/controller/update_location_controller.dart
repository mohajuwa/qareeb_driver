// ignore_for_file: unused_import, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/config/config.dart';
import '../config/data_store.dart';
import '../model/update_location_model.dart';
import '../widget/common.dart';

class UpdateLocationController extends GetxController implements GetxService {
  UpdateLocationModel? updateLocationModel;

  Future updateLocationAPi({
    required String lat,
    required String long,
    required String status,
  }) async {
    Map body = {
      "id": getData.read("UserLogin")['id'],
      "lat": lat,
      "lon": long,
      "live_status": status,
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    var response = await http.post(
      Uri.parse(Config.baseUrl + Config.updateLocation),
      body: jsonEncode(body),
      headers: userHeader,
    );

    print("+++++++++++++++++ ${body}");
    print("+++++++++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        updateLocationModel = updateLocationModelFromJson(response.body);
        if (updateLocationModel!.result == true) {
          update();
          // snackBar(context: context, text: "${data["message"]}");
          return response.body;
        } else {
          // snackBar(context: context, text: updateLocationModel!.message.toString());
        }
      } else {
        // snackBar(context: context, text: "${data["message"]}");
      }
    } else {
      // snackBar(context: context, text: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}
