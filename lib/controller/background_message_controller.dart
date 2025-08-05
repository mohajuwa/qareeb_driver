// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/background_message_model.dart';


class BackGroundMessageController extends GetxController implements GetxService {

  BackgroundMessageModel? backgroundMessageModel;

   backgroundUpdateApi() async {

    Map body = {
      "id": getData.read("UserLogin")['id'],
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    var response = await http.post(Uri.parse(Config.baseUrl + Config.backgroundUpdate),body: jsonEncode(body),headers: userHeader);

    print("+++++++++++++++++ ${body}");
    print("+++++++++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        backgroundMessageModel = backgroundMessageModelFromJson(response.body);
        if (backgroundMessageModel!.result == true) {
          update();
        }
      }
    }
  }
}