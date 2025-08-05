// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/config/config.dart';
import 'package:qareeb/controller/wallet_controller.dart';
import '../config/data_store.dart';
import '../model/payout_wallet_model.dart';
import '../widget/common.dart';

class PayoutWalletController extends GetxController implements GetxService {
  WalletDetailController walletDetailController = Get.put(
    WalletDetailController(),
  );

  PayoutWalletModel? payoutWalletModel;

  TextEditingController payoutAmountController = TextEditingController();
  TextEditingController payoutUpiController = TextEditingController();
  TextEditingController payoutAccountNumberController = TextEditingController();
  // TextEditingController bankNameController = TextEditingController();
  // TextEditingController cardNameController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  String? selectType;
  String? bankType;

  emptyDetails() {
    payoutAmountController.text = "";
    payoutUpiController.text = "";
    emailIdController.text = "";
    payoutAccountNumberController.text = "";
    ifscController.text = "";
    // selectType = "";
    // bankType = "";
    update();
  }

  payoutApi({required context}) async {
    Map body = {
      "id": getData.read("UserLogin")['id'].toString(),
      "Withdraw_amount": payoutAmountController.text,
      "payment_type": selectType, // UPI, Paypal, BANK Transfer
      "upi_id": payoutUpiController.text,
      "paypal_id": emailIdController.text,
      "bank_no": payoutAccountNumberController.text,
      "bank_ifsc": ifscController.text,
      "bank_type": bankType,
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    var response = await http.post(
      Uri.parse(Config.baseUrl + Config.payout),
      body: jsonEncode(body),
      headers: userHeader,
    );

    print("+++++++++++++++++ ${body}");
    print("+++++++++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        payoutWalletModel = payoutWalletModelFromJson(response.body);
        if (payoutWalletModel!.result == true) {
          Get.back();
          emptyDetails();
          walletDetailController.walletApi(context: context);
          snackBar(
            context: context,
            text: payoutWalletModel!.message.toString(),
          );
          update();
        } else {
          Get.back();
          snackBar(
            context: context,
            text: payoutWalletModel!.message.toString(),
          );
        }
      } else {
        Get.back();
        snackBar(context: context, text: "${data["message"]}");
      }
    } else {
      Get.back();
      snackBar(
        context: context,
        text:
            "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",
      );
    }
  }
}
