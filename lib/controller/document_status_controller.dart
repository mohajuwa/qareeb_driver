// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/config/config.dart';
import '../config/data_store.dart';
import '../model/document_status_model.dart';
import '../widget/common.dart';

class DocumentStatusController extends GetxController implements GetxService {
  DocumentStatusModel? documentStatusModel;

  Future documentStatusApi({required context}) async {
    Map body = {"id": getData.read("UserLogin")['id']};
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    var response = await http.post(
      Uri.parse(Config.baseUrl + Config.documentStatus),
      body: jsonEncode(body),
      headers: userHeader,
    );

    print("twilioApi body ${body}");
    print("twilioapi repsone ${response.body}");

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        documentStatusModel = documentStatusModelFromJson(response.body);
        if (documentStatusModel!.result == true) {
          update();
          return response.body;
        } else {
          snackBar(
            context: context,
            text: documentStatusModel!.message.toString(),
          );
        }
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
