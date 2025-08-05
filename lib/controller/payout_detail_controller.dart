// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/payout_detail_model.dart';
import '../widget/common.dart';

class PayoutDetailController extends GetxController implements GetxService {

  PayoutDetailModel? payoutDetailModel;
  bool isLoading = false;

  payoutDetailApi({required context}) async{

    Map body = {
      "id": getData.read("UserLogin")['id'].toString()
    };
    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrl + Config.payoutDetails),body: jsonEncode(body),headers: userHeader);

    print("+++++++++++++++++ ${body}");
    print("+++++++++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        payoutDetailModel = payoutDetailModelFromJson(response.body);
        if(payoutDetailModel!.result == true){
          isLoading = true;
          update();

        }else{
          snackBar(context: context, text: payoutDetailModel!.message.toString());
        }
      }else{
        snackBar(context: context, text: "${data["message"]}");
      }
    }else{
      snackBar(context: context, text: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }

  }
}