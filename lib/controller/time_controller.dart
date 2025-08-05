// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/time_model.dart';
import '../widget/common.dart';

class TimeController extends GetxController implements GetxService {

  TimeModel? timeModel;

  Future timeApi({required context,required String requestId,required String cId, required String time}) async{

    Map body = {
      "uid": getData.read("UserLogin")['id'],
      "request_id": requestId,
      "c_id": cId,
      "time": time,
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    var response = await http.post(Uri.parse(Config.baseUrl + Config.timeSend),body: jsonEncode(body),headers: userHeader);

    print("+++++++++++++++++ ${body}");
    print("+++++++++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        timeModel = timeModelFromJson(response.body);
        if (timeModel!.result == true) {

          update();
          return response.body;

        } else {
          snackBar(context: context, text: timeModel!.message.toString());
        }
      } else {
        snackBar(context: context, text: "${data["message"]}");
      }
    } else {
      snackBar(context: context, text: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }

  }
}