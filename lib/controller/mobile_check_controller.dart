// ignore_for_file: unused_import

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';
import '../model/mobile_check_model.dart';
import '../screen/home/home_screen.dart';
import '../widget/common.dart';

class MobileCheckController extends GetxController implements GetxService {

  MobileCheckModel? mobileCheckModel;

  Future mobileCheckApi({required context,required String primaryCode,required String primaryPhone, required String secondCode,required String secondPhone}) async{

    Map body = {
      "primary_ccode": primaryCode,
      "primary_phoneNo": primaryPhone,
      "secound_ccode": secondCode,
      "secound_phoneNo": secondPhone,
      "password": ""
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    var response = await http.post(Uri.parse(Config.baseUrl + Config.mobileCheck),body: jsonEncode(body),headers: userHeader);

    print("1111111  $body");
    print("111111111111 ${response.body}");
    print("+++++++++ ${Config.baseUrl + Config.mobileCheck}");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        mobileCheckModel = mobileCheckModelFromJson(response.body);
        if(mobileCheckModel!.result == true){

          // Get.offAll(const HomeScreen());
          // snackBar(context: context, text: data["message"]);
          update();
          return response.body;
        }else{
          // snackBar(context: context, text: mobileCheckModel!.message);
          update();
          return response.body;
        }
      }else{
        // snackBar(context: context, text: data["message"]);
        update();
        return response.body;
      }
    }else{
      snackBar(context: context, text: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}