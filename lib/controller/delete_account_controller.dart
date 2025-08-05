import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/config/config.dart';
import 'package:qareeb/screen/auth_screen/login_screen.dart';
import '../config/data_store.dart';
import '../widget/common.dart';

class AccountDeleteController extends GetxController implements GetxService {
  Future deleteAccountApi({required context}) async {
    Map body = {"id": getData.read("UserLogin")['id']};
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    var response = await http.post(
      Uri.parse(Config.baseUrl + Config.deleteAccount),
      body: jsonEncode(body),
      headers: userHeader,
    );

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        update();
        return response.body;
      } else {
        snackBar(context: context, text: "${data["message"]}");
      }
    } else {
      snackBar(
        context: context,
        text:
            "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",
      );
    }
  }
}
