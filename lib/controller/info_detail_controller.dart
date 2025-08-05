// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';
import '../model/info_detail_model.dart';
import '../widget/common.dart';

class InfoDetailController extends GetxController implements GetxService {

  InfoDetailModel? infoDetailModel;
  bool isLoading = false;

  Future infoDetailApi({required context}) async{

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.get(Uri.parse(Config.baseUrl + Config.infoDetail),headers: userHeader);

    // log('${response.body}');

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        infoDetailModel = infoDetailModelFromJson(response.body);
        if(infoDetailModel!.result == true){
          isLoading = true;
          update();
        }else{

        }
      }
      else{
        // snackBar(context: context,text: "${data[""]}");
      }
    }
    else{
      snackBar(context: context,text: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");

    }
  }
}