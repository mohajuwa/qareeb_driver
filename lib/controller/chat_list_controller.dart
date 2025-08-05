// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/chat_list_model.dart';
import '../widget/common.dart';

class ChatListController extends GetxController implements GetxService {
  ChatListModel? chatListModel;
  bool isLoading = false;

  Future chatListApi({required context,required String customer}) async{
    Map body = {
      "uid": getData.read("UserLogin")['id'],
      "sender_id": getData.read("UserLogin")['id'],
      "recevier_id": customer,
      "status": "driver" // customer, driver
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    var response = await http.post(Uri.parse(Config.chatUrl + Config.chatList),body: jsonEncode(body),headers: userHeader);

    print("+++++++++++++++++ ${body}");
    print("+++++++++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        chatListModel = chatListModelFromJson(response.body);
        if (chatListModel!.result == true) {
          isLoading = true;
          update();
          return response.body;
        } else {
          snackBar(context: context, text: chatListModel!.message.toString());
        }
      } else {
        snackBar(context: context, text: "${data["message"]}");
      }
    } else {
      snackBar(context: context, text: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}