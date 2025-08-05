// ignore_for_file: unnecessary_string_interpolations, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/my_earning_model.dart';
import '../widget/common.dart';

class MyEarningController extends GetxController implements GetxService {
  MyEarningModel? myEarningModel;
  bool isLoading = false;

  myEarningApi({required context,required String selection}) async{
    Map body = {
      "uid": getData.read("UserLogin")["id"].toString(),
      "time": selection
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    var response = await http.post(Uri.parse(Config.baseUrl + Config.myEarning),body: jsonEncode(body),headers: userHeader);

    print("${response.body}");
    print("${body}");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        myEarningModel = myEarningModelFromJson(response.body);
        if(myEarningModel!.result == true){
          isLoading = true;
          update();

        }else{
          snackBar(context: context, text: myEarningModel!.message.toString());
        }
      }else{
        snackBar(context: context, text: "${data["message"]}");
      }
    }else{
      snackBar(context: context, text: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }

  }

}