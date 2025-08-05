import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:qareeb/controller/total_cash_controller.dart';
import '../config/config.dart';
import '../config/data_store.dart';
import '../widget/common.dart';

class AddCashController extends GetxController implements GetxService {
  TotalCashController totalCashController = Get.put(TotalCashController());

  bool isLoading = true;

  TextEditingController cashAmountController = TextEditingController();
  String? selectType;

  File? galleryFileFront;
  XFile? xFileImageFront;

  emptyDetails() {
    cashAmountController.text = "";
    update();
  }

  // Future addCashApi({required context}) async {
  //
  //   var request = http.MultipartRequest('POST', Uri.parse(Config.baseUrl + Config.addCash));
  //   request.fields.addAll({
  //     'id': getData.read("UserLogin")['id'].toString(),
  //     'payment_type': "$selectType",
  //     'cash_amount': cashAmountController.text
  //   });
  //
  //   // if (frontImage != null && frontImage.isNotEmpty) {
  //   //   request.files.add(await http.MultipartFile.fromPath('frontimg', frontImage));
  //   // }
  //
  //   request.files.add(await http.MultipartFile.fromPath('image', xFileImageFront!.path));
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //     isLoading = false;
  //     Get.back();
  //     totalCashController.totalCashApi(context: context);
  //     snackBar(context: context, text: "Payout Done Successfully");
  //     update();
  //   } else {
  //     Get.back();
  //     snackBar(context: context, text: "Internal Server error");
  //     print(response.reasonPhrase);
  //   }
  // }

  Future addCashApi({required BuildContext context}) async {
    isLoading = true;
    update(); // To trigger loading state in the UI

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Config.baseUrl + Config.addCash),
    );
    request.fields.addAll({
      'id': getData.read("UserLogin")['id'].toString(),
      'payment_type': "$selectType",
      'cash_amount': cashAmountController.text,
    });

    request.files.add(
      await http.MultipartFile.fromPath('image', xFileImageFront!.path),
    );

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      isLoading = false;
      Get.back();
      totalCashController.totalCashApi(context: context);
      snackBar(context: context, text: "Payout Done Successfully");
      update();
    } else {
      isLoading = false;
      Get.back();
      snackBar(context: context, text: "Internal Server error");
      print(response.reasonPhrase);
      update();
    }
  }
}
