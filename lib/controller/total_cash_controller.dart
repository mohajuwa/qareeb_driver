// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/total_cash_model.dart';
import '../widget/common.dart';

class TotalCashController extends GetxController implements GetxService {

  TotalCashModel? totalCashModel;
  bool isLoading = false;

  totalCashApi({required context}) async{
    Map body =  {
      "id": getData.read("UserLogin")['id'].toString()
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    var response = await http.post(Uri.parse(Config.baseUrl + Config.totalCash),body: jsonEncode(body),headers: userHeader);

    print("+++++++++++++++++ ${body}");
    print("+++++++++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        totalCashModel = totalCashModelFromJson(response.body);
        if (totalCashModel!.result == true) {
          isLoading = true;
          update();
        } else {
          snackBar(context: context, text: totalCashModel!.message.toString());
        }
      } else {
        snackBar(context: context, text: "${data["message"]}");
      }
    } else {
      snackBar(context: context, text: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}