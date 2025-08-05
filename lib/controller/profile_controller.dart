// ignore_for_file: unused_import, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/profile_model.dart';
import '../model/review_detail_model.dart';
import '../model/wallet_model.dart';
import '../widget/common.dart';

class ProfileController extends GetxController implements GetxService {

  ProfileModel? profileModel;
  bool isLoading = false;

  Future profileApi({required context}) async {
    Map body = {
      "uid": getData.read("UserLogin")['id']
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    var response = await http.post(Uri.parse(Config.baseUrl + Config.profile),body: jsonEncode(body),headers: userHeader);

    print("123//522452 ${response.body}");
    print("kdhsdfsfudgfygf ${body}");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        profileModel = profileModelFromJson(response.body);
        if(profileModel!.result == true){
          isLoading = true;
          update();
          return response.body;

        }else{
          snackBar(context: context, text: profileModel!.message.toString());
        }
      }else{
        snackBar(context: context, text: "${data["message"]}");
      }
    }else{
      snackBar(context: context, text: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }

  }

}