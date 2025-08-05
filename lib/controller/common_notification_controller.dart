// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/common_notification_model.dart';
import '../widget/common.dart';

class CommonNotificationController extends GetxController implements GetxService{

  bool isLoading = false;
  CommonNotificationModel? commonNotificationModel;

   commonNotificationApi({required context}) async {
     Map body = {
       "uid": getData.read("UserLogin")['id'].toString()
     };

     Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

     var response = await http.post(Uri.parse(Config.baseUrl + Config.commonNotification),body: jsonEncode(body),headers: userHeader);

     print("+++++++commonNotificationApi++++++++++ ${body}");
     print("+++++++commonNotificationApi++++++++++ ${response.body}");

     var data = jsonDecode(response.body);
     if (response.statusCode == 200) {
       if (data["Result"] == true) {
         commonNotificationModel = commonNotificationModelFromJson(response.body);
         if (commonNotificationModel!.result == true) {
           isLoading = true;
           update();
           return response.body;
         } else {
           snackBar(context: context, text: commonNotificationModel!.message.toString());
         }
       } else {
         snackBar(context: context, text: "${data["message"]}");
       }
     } else {
       snackBar(context: context, text: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
     }
   }
}