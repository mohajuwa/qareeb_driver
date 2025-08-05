// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/config/config.dart';
import 'package:qareeb/screen/auth_screen/vechile_info.dart';
import 'package:qareeb/utils/colors.dart';
import 'package:qareeb/widget/common.dart';
import 'dart:ui' as ui;
import '../config/data_store.dart';
import '../utils/font_family.dart';

class PersonalInfoController extends GetxController implements GetxService {
  File? galleryFile;
  XFile? xFileImage;

  bool isLoading = false;

  // String primaryccode = "";
  String secondaryccode = "";
  DateTime selectedDate = DateTime.now();

  final languageTagController = StringTagController();
  List<String> languageTagList = [];

  late StringTagController<String> zoneTagController = StringTagController();
  List<String> zoneTagList = [];

  TextEditingController dateController = TextEditingController();
  // TextEditingController primaryPhone = TextEditingController();
  TextEditingController secondaryPhone = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController zoneController = TextEditingController();
  String zoneId = "";

  bool obscureText = true;

  List zoneList = [];

  emptyAllDetail() {
    firstName.text = "";
    lastName.text = "";
    email.text = "";
    // primaryPhone.text = "";
    secondaryPhone.text = "";
    // primaryccode = "";
    secondaryccode = "";
    password.text = "";
    nationality.text = "";
    galleryFile = null;
    dateController.text = "";
    address.text = "";
    zoneId = "";
    zoneList = [];
    languageTagController.getTags!.clear();
  }

  Future personalInfoApi({
    required context,
    required String primaryCode,
    required String primaryPhone,
  }) async {
    String tag = languageTagController.getTags!.join(",");
    String zoneData = "$zoneList";
    String finalZoneData = zoneData.replaceAll(RegExp(r'[\[\] ]'), '');
    print("********************* $finalZoneData");
    // var headers = {'Cookie': 'connect.sid=s%3AJvm_IW9I_E871xlm09Y5pMpe0C11cw8u.GJRR%2FghECVmP4hzArAHWhArAKnOJ3WKOonlT620y%2F6k'};

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Config.baseUrl + Config.personalInfo),
    );
    request.fields.addAll({
      'first_name': firstName.text,
      'last_name': lastName.text,
      'email': email.text,
      'primary_ccode': primaryCode,
      'primary_phoneNo': primaryPhone,
      'secound_ccode': secondaryccode,
      'secound_phoneNo': secondaryPhone.text,
      'password': password.text,
      'nationality': nationality.text,
      'date_of_birth': dateController.text,
      'complete_address': address.text,
      'zone': finalZoneData.toString(),
      'language': tag,
    });
    request.files.add(
      await http.MultipartFile.fromPath('profile_image', xFileImage!.path),
    );
    // request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      String responseBody = await response.stream.bytesToString();
      // print("+++++++++++responseBody+++++++++++++++++++ ${responseBody}");
      Map<String, dynamic> data = jsonDecode(responseBody);
      print("++++++++++++++++++++++++++++++ ${data}");
      save("UserLogin", data["driver_data"]);
      save("Currency", data["general"]["site_currency"]);

      print("+++++++++++++userData----------- ${getData.read("UserLogin")}");
      print(
        "+++++++++++++ID+++++++++++++++++++ ${getData.read("UserLogin")['id']}",
      );
      print(
        "++++++++++++++++++++++++++++++++++++++++ ${getData.read("Currency")}",
      );
      bottomSheet();
      isLoading = false;
      update();
    } else {
      print(response.reasonPhrase);
      snackBar(context: context, text: "SomeThing Went Wrong");
    }
  }

  Future bottomSheet() {
    return Get.bottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      StatefulBuilder(
        builder: (context, setState) {
          return BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                color: whiteColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/image/uplodeimage.png"),
                  const SizedBox(height: 20),
                  Text(
                    "Registered Successfully",
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 20,
                      fontFamily: FontFamily.sofiaProBold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Congratulation! your account already has been created. Please login to get amazing experience.",
                    style: TextStyle(
                      color: greyText,
                      fontSize: 15,
                      fontFamily: FontFamily.sofiaProRegular,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  button(
                    text: "CONTINUE",
                    color: appColor,
                    onPress: () {
                      Get.back();
                      Get.to(const VehicleInfoScreen());
                      emptyAllDetail();
                      update();
                    },
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
