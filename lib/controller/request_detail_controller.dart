// ignore_for_file: unused_import, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/request_detail_model.dart';
import '../screen/home/sound_player.dart';
import '../widget/common.dart';

class RequestDetailController extends GetxController implements GetxService {
  final NotificationSoundPlayer notificationSoundPlayer = NotificationSoundPlayer();

  RequestDetailModel? requestDetailModel;
  bool isLoading = false;


  // Future requestDetailApi({required String requestId}) async{
  //   notificationSoundPlayer.stopNotificationSound();
  //   Map body = {
  //     "uid": getData.read("UserLogin")['id'],
  //     "request_id": requestId
  //   };
  //
  //   Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
  //
  //   var response = await http.post(Uri.parse(Config.baseUrl + Config.requestDetail),body: jsonEncode(body),headers: userHeader);
  //
  //   print("++++++bodybodybodybody+++++++++++ ${body}");
  //   print("+++++++response.bodyresponse.bodyresponse.bodyresponse.body++++++++++ ${response.body}");
  //
  //   var data = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     if (data["Result"] == true) {
  //       requestDetailModel = requestDetailModelFromJson(response.body);
  //       if (requestDetailModel!.result == true) {
  //         isLoading = true;
  //         update();
  //         return response.body;
  //
  //       } else {
  //         // snackBar(context: context, text: requestDetailModel!.message.toString());
  //       }
  //     } else {
  //       // snackBar(context: context, text: "${data["message"]}");
  //     }
  //   } else {
  //     // snackBar(context: context, text: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
  //   }
  //
  // }

  Future requestDetailApi({required String requestId}) async {
    notificationSoundPlayer.stopNotificationSound();

    Map body = {
      "uid": getData.read("UserLogin")['id'],
      "request_id": requestId
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrl + Config.requestDetail),
        body: jsonEncode(body),
        headers: userHeader,
      );

      print("Request body: $body");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data is Map<String, dynamic> && data["Result"] == true) {
          try {
            requestDetailModel = requestDetailModelFromJson(response.body);

            if (requestDetailModel != null && requestDetailModel!.result == true) {
              isLoading = true;
              update();
              return response.body;
            } else {
              print('Error: requestDetailModel is null or result is false');
            }
          } catch (e) {
            print('Error parsing RequestDetailModel: $e');
          }
        } else {
          print('Error: Invalid or unexpected API response');
        }
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }

}