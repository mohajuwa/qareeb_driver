// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:qareeb/controller/verification_check_controller.dart';
// import '../config/config.dart';
// import '../config/data_store.dart';
// import '../widget/common.dart';
//
// class AddDocumentController extends GetxController implements GetxService {
//
//   bool isLoading = true;
//   VerificationCheckController verificationCheckController = Get.put(VerificationCheckController());
//
//   Future addDocumentApi({required context, required String docId, required String fname, String? frontImage, String? backImage,}) async {
//
//     var request = http.MultipartRequest('POST', Uri.parse(Config.baseUrl + Config.addDocument));
//     request.fields.addAll({
//       'id': getData.read("UserLogin")["id"].toString(),
//       'doc_id': docId,
//       'fname': fname,
//     });
//
//     if (frontImage != null && frontImage.isNotEmpty) {
//       request.files.add(await http.MultipartFile.fromPath('frontimg', frontImage));
//     }
//
//     if (backImage != null && backImage.isNotEmpty) {
//       request.files.add(await http.MultipartFile.fromPath('backimg', backImage));
//     }
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       print(await response.stream.bytesToString());
//       isLoading = false;
//       Get.back();
//       verificationCheckController.verificationCheckApi(context: context);
//       snackBar(context: context, text: "Document Added Successfully");
//       update();
//     } else {
//       print(response.reasonPhrase);
//     }
//   }
// }

import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/controller/verification_check_controller.dart';
import '../config/config.dart';
import '../config/data_store.dart';
import '../widget/common.dart';

class AddDocumentController extends GetxController implements GetxService {
  bool isLoading = true;
  VerificationCheckController verificationCheckController = Get.put(
    VerificationCheckController(),
  );

  Future addDocumentApi({
    required context,
    required String docId,
    required String fname,
    String? frontImage,
    String? backImage,
  }) async {
    // Check if front image size exceeds 1 MB
    if (frontImage != null && frontImage.isNotEmpty) {
      int frontFileSizeInBytes = File(frontImage).lengthSync();
      double frontFileSizeInMB =
          frontFileSizeInBytes / (1024 * 1024); // Convert bytes to MB
      if (frontFileSizeInMB > 1) {
        snackBar(
          context: context,
          text: "Image size exceeds 1 MB. Please select a smaller file.",
        );
        return;
      }
    }

    // Check if back image size exceeds 1 MB
    if (backImage != null && backImage.isNotEmpty) {
      int backFileSizeInBytes = File(backImage).lengthSync();
      double backFileSizeInMB =
          backFileSizeInBytes / (1024 * 1024); // Convert bytes to MB
      if (backFileSizeInMB > 1) {
        snackBar(
          context: context,
          text: "Image size exceeds 1 MB. Please select a smaller file.",
        );
        return;
      }
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Config.baseUrl + Config.addDocument),
    );
    request.fields.addAll({
      'id': getData.read("UserLogin")["id"].toString(),
      'doc_id': docId,
      'fname': fname,
    });

    if (frontImage != null && frontImage.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath('frontimg', frontImage),
      );
    }

    if (backImage != null && backImage.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath('backimg', backImage),
      );
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      isLoading = false;
      Get.back();
      verificationCheckController.verificationCheckApi(context: context);
      snackBar(context: context, text: "Document Added Successfully");
      update();
    } else {
      print(response.reasonPhrase);
    }
  }
}
