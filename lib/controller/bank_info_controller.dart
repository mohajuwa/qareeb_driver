// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/screen/auth_screen/verification_process.dart';

import '../config/config.dart';
import '../config/data_store.dart';
import '../model/bank_info_model.dart';
import '../widget/common.dart';

class BankInfoController extends GetxController implements GetxService {
  BankInfoModel? bankInfoModel;
  TextEditingController ibanNumberController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController holderNameController = TextEditingController();
  TextEditingController vatIdController = TextEditingController();

  bool isLoading = true;

  Future bankInfoApi({required context}) async {
    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "iban_number": ibanNumberController.text,
      "bank_name": bankNameController.text,
      "account_hol_name": holderNameController.text,
      "vat_id": vatIdController.text,
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    var response = await http.post(
      Uri.parse(Config.baseUrl + Config.bankInfo),
      body: jsonEncode(body),
      headers: userHeader,
    );

    print("bankInfoApi body ${body}");
    print("bankInfoApi repsone ${response.body}");

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        bankInfoModel = bankInfoModelFromJson(response.body);
        if (bankInfoModel!.result == true) {
          save("UserLogin", data["driver_data"]);
          // save("Currency", data["general"]["site_currency"]);
          print("++++++++UserLogin++++++++++++ ${getData.read("UserLogin")}");
          print("++++++++ID++++++++++++ ${getData.read("UserLogin")["id"]}");
          // print("++++++++++++++++++++++++++++++++++++++++ ${getData.read("Currency")}");
          isLoading = false;
          Get.to(const VerificationProcessScreen());
          snackBar(context: context, text: "${data["message"]}");
          update();
        } else {
          snackBar(context: context, text: bankInfoModel!.message.toString());
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
