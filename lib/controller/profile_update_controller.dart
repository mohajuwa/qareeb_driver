// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:qareeb/config/config.dart';
import 'package:qareeb/controller/profile_controller.dart';
import 'package:qareeb/widget/common.dart';
import '../config/data_store.dart';
import 'package:path/path.dart';

class EditProfileController extends GetxController implements GetxService {
  ProfileController profileController = Get.put(ProfileController());

  File? profileImage;
  XFile? xFileImageProfile;
  bool isLoading = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  emptyAllDetail() {
    firstNameController.text = "";
    lastNameController.text = "";
    profileImage = null;
  }

  editProfileApi({
    required context,
    required String firstName,
    required String lastName,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Config.baseUrl + Config.editProfile),
    );
    request.fields.addAll({
      'uid': getData.read("UserLogin")['id'].toString(),
      'first_name': firstName,
      'last_name': lastName,
    });
    xFileImageProfile != null
        ? request.files.add(
            await http.MultipartFile.fromPath(
              'profile_image',
              xFileImageProfile!.path,
            ),
          )
        : null;

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      isLoading = false;
      print(await response.stream.bytesToString());
      profileController.profileApi(context: context).then((value) {
        Map<String, dynamic> data = json.decode(value);
        if (data["Result"] == true) {
          Get.back();
          save("UserLogin", data["profile_data"]);
          snackBar(context: context, text: "Profile update Successfully");
          update();
        } else {
          snackBar(context: context, text: "Profile update Successfully");
        }
        update();
      });
    } else {
      print(response.reasonPhrase);
    }
  }
  // Future<File> urlToFile(String imageUrl) async {
  //   try {
  //     var response = await http.get(Uri.parse(imageUrl));
  //
  //     if (response.statusCode == 200) {
  //       var dir = await getTemporaryDirectory();
  //
  //       String filename = basename(imageUrl);
  //       File file = File('${dir.path}/$filename');
  //
  //       await file.writeAsBytes(response.bodyBytes);
  //       update();
  //
  //       return File(file.path);
  //     } else {
  //       throw Exception('Failed to download image');
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     throw e;
  //   }
  // }
}
