import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:qareeb/config/config.dart';
import 'package:qareeb/screen/auth_screen/bank_info_screen.dart';
import 'package:qareeb/widget/common.dart';

import '../config/data_store.dart';

class DriverInfoController extends GetxController implements GetxService {
  File? galleryFile;
  XFile? xFileImage;
  bool isLoading = false;

  TextEditingController vehicleController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  // TextEditingController preferenceController = TextEditingController();
  List preferenceList = [];
  String vehicleId = "";
  // String preferenceId = "";

  driverInfoApi({required context}) async {
    String preferenceData = "$preferenceList";
    String finalPreferenceData = preferenceData.replaceAll(
      RegExp(r'[\[\] ]'),
      '',
    );
    print("********************* $finalPreferenceData");

    // var userLoginData = getData.read("UserLogin");
    // print("++++++++++++++++++ $userLoginData");
    // print(userLoginData.runtimeType);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Config.baseUrl + Config.driverInfo),
    );
    request.fields.addAll({
      'id': getData.read("UserLogin")["id"].toString(),
      'vehicle': vehicleId.toString(),
      'vehicle_number': vehicleNumberController.text,
      'car_color': colorController.text,
      'passenger_capacity': capacityController.text,
      'vehicle_prefrence': finalPreferenceData.toString(),
    });
    request.files.add(
      await http.MultipartFile.fromPath('vehicle_image', xFileImage!.path),
    );

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      isLoading = false;
      print(await response.stream.bytesToString());
      Get.to(const BankInfoScreen());
      snackBar(context: context, text: "Vehicles Information Add Successfully");
      update();
    } else {
      print(response.reasonPhrase);
    }
  }
}
