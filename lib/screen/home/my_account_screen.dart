// ignore_for_file: unused_import

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textfield_tags/textfield_tags.dart';
import '../../config/config.dart';
import '../../controller/profile_controller.dart';
import '../../controller/profile_update_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import 'dart:ui' as ui;
import '../../widget/common.dart';
import '../../widget/dark_light_mode.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {

  ProfileController profileController = Get.put(ProfileController());
  EditProfileController editProfileController = Get.put(EditProfileController());

  @override
  void initState() {
    getDarkMode();
    profileController.profileApi(context: context);
    super.initState();
  }
  get picker => ImagePicker();

  late ColorNotifier notifier;

  getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previousState = prefs.getBool("setIsDark");
    if (previousState == null) {
      notifier.setIsDark = false;
    } else {
      notifier.setIsDark = previousState;
    }
  }


  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: notifier.background,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: notifier.containerColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: notifier.textColor),
          onPressed: () {
            Get.back();
            setState(() { });
          },
        ),
        title: Text(
          "Profile".tr,
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 18,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              editBottom();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8,right: 10,bottom: 15),
              child: Container(
                padding: const EdgeInsets.only(left: 13,right: 13),
                decoration: BoxDecoration(
                  color: appColor,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 3),
                        Text(
                          "EDIT".tr,
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 13.5,
                            letterSpacing: 0.5,
                            fontFamily: FontFamily.sofiaProBold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: GetBuilder<ProfileController>(
        builder: (context) {
          return profileController.isLoading
              ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.all(10),
                  color: notifier.containerColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PERSONAL INFO".tr,
                        style:  TextStyle(
                          fontFamily: FontFamily.sofiaProBold,
                          color: appColor,
                          letterSpacing: 0.5,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Container(
                          // margin: const EdgeInsets.all(10),
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: notifier.containerColor,
                            border: Border.all(color: Colors.grey.shade300),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(65),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/image/ezgif.com-crop.gif",
                              placeholderCacheWidth: 50,
                              placeholderCacheHeight: 50,
                              image: "${Config.imageUrl}${profileController.profileModel!.profileData.profileImage}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          "${profileController.profileModel!.profileData.firstName} ${profileController.profileModel!.profileData.lastName}",
                          style: TextStyle(
                            fontFamily: FontFamily.sofiaProBold,
                            letterSpacing: 0.5,
                            color: notifier.textColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          "Driving Since ${profileController.profileModel!.profileData.date}",
                          style:  TextStyle(
                            fontFamily: FontFamily.sofiaProRegular,
                            color: greyText,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text("${profileController.profileModel!.profileData.primaryCcode} ${profileController.profileModel!.profileData.primaryPhoneNo}",
                          style:  TextStyle(
                            fontFamily: FontFamily.sofiaProRegular,
                            color: greyText,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      data(title: "E-mail".tr, value: profileController.profileModel!.profileData.email),
                      data(title: "Secondary No.".tr, value: "${profileController.profileModel!.profileData.secoundCcode} ${profileController.profileModel!.profileData.secoundPhoneNo}"),
                      data(title: "Nationality".tr, value: profileController.profileModel!.profileData.nationality),
                      data(title: "DOB".tr, value: profileController.profileModel!.profileData.dateOfBirth),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Address",
                              style: TextStyle(
                                color: greyText,
                                fontSize: 15,
                                fontFamily: FontFamily.sofiaProRegular,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                profileController.profileModel!.profileData.comAddress,
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 15,
                                  fontFamily: FontFamily.sofiaProRegular,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      data(title: "Zone".tr, value: profileController.profileModel!.profileData.zoneName),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Language".tr,
                              style: TextStyle(
                                color: greyText,
                                fontSize: 15,
                                fontFamily: FontFamily.sofiaProRegular,
                              ),
                            ),
                            Flexible(
                              child: SizedBox(
                                width: 120,
                                child: Text(
                                  profileController.profileModel!.profileData.language,
                                  style: TextStyle(
                                    color: notifier.textColor,
                                    fontSize: 15,
                                    fontFamily: FontFamily.sofiaProRegular,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(10),
                  color: notifier.containerColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "VEHICLE INFO".tr,
                        style:  TextStyle(
                          fontFamily: FontFamily.sofiaProBold,
                          color: appColor,
                          letterSpacing: 0.5,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Container(
                          // margin: const EdgeInsets.all(10),
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            border: Border.all(color: Colors.grey.shade300),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(65),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/image/ezgif.com-crop.gif",
                              placeholderCacheWidth: 50,
                              placeholderCacheHeight: 50,
                              image: "${Config.imageUrl}${profileController.profileModel!.profileData.vehicleImage}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      data(title: "Vehicle Type".tr, value: profileController.profileModel!.profileData.vname),
                      data(title: "Vehicle Number".tr, value: profileController.profileModel!.profileData.vehicleNumber),
                      data(title: "Vehicle Color".tr, value: profileController.profileModel!.profileData.carColor),
                      data(title: "Passenger Capacity".tr, value: profileController.profileModel!.profileData.passengerCapacity),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Passenger Preference".tr,
                              style: TextStyle(
                                color: greyText,
                                fontSize: 15,
                                fontFamily: FontFamily.sofiaProRegular,
                              ),
                            ),
                            Flexible(
                              child: SizedBox(
                                width: 140,
                                child: Text(
                                  profileController.profileModel!.profileData.prefrenceName,
                                  style: TextStyle(
                                    color: notifier.textColor,
                                    fontSize: 15,
                                    fontFamily: FontFamily.sofiaProRegular,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(10),
                  color: notifier.containerColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BANK INFO".tr,
                        style:  TextStyle(
                          fontFamily: FontFamily.sofiaProBold,
                          color: appColor,
                          letterSpacing: 0.5,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      data(title: "Bank Holder Name".tr, value: profileController.profileModel!.profileData.accountHolName),
                      data(title: "Bank Name".tr, value: profileController.profileModel!.profileData.bankName),
                      data(title: "IBAN Number".tr, value: profileController.profileModel!.profileData.ibanNumber),
                      data(title: "VAT Id".tr, value: profileController.profileModel!.profileData.vatId),
                    ],
                  ),
                ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
              : Center(
              child: CircularProgressIndicator(color: appColor,));
        }
      ),
    );
  }

  Widget data({required String title ,required String value}){
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text(
            title,
            style: TextStyle(
              color: greyText,
              fontSize: 15,
              fontFamily: FontFamily.sofiaProRegular,
            ),
          ),
      Flexible(
        child: Text(
            value,
            style: TextStyle(
              color: notifier.textColor,
              fontSize: 15,
              fontFamily: FontFamily.sofiaProRegular,
            ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          ),
      ),
        ],
      ),
    );
  }

  Future getImageProfile(ImageSource img,context) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xFilePick = pickedFile;
    if (xFilePick != null) {
      editProfileController.profileImage = File(pickedFile!.path);
      editProfileController.xFileImageProfile = xFilePick;
      setState(() { });
    }
    else {
      snackBar(context: context, text: "Nothing is Selected".tr);
    }
    setState(() { });
  }

  List<String> languageList = [];

  Future editBottom() async {
    editProfileController.emptyAllDetail();
    String languageString = profileController.profileModel!.profileData.language;
     languageList = languageString.split(',').map((lang) => lang.trim()).toList();
     // String defaultString = profileController.profileModel!.profileData.language;
    // defaultString = editProfileController.languageTagController.;

    // String imageUrl = profileController.profileModel!.profileData.profileImage;
    // String fullUrl = "${Config.imageUrl}$imageUrl"; // Update with the base URL
    // File? fileImage = await editProfileController.urlToFile(fullUrl);
    return Get.bottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      StatefulBuilder(
        builder: (context, setState) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 1.4, sigmaY: 1.4),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: notifier.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "EDIT PROFILE".tr,
                    style:  TextStyle(
                      fontFamily: FontFamily.sofiaProBold,
                      color: appColor,
                      letterSpacing: 0.5,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                GestureDetector(
                  onTap: (){
                    getImageProfile(ImageSource.gallery,context).then((value) {
                      setState(() { });
                    },);
                  },
                  child: Center(
                    child: Stack(
                      children: [
                        editProfileController.profileImage == null
                            ? Container(
                          // margin: const EdgeInsets.all(10),
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            border: Border.all(color: Colors.grey.shade300),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(65),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/image/ezgif.com-crop.gif",
                              placeholderCacheWidth: 50,
                              placeholderCacheHeight: 50,
                              image: "${Config.imageUrl}${profileController.profileModel!.profileData.profileImage}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                             : Container(
                          // margin: const EdgeInsets.all(10),
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: notifier.containerColor,
                            border: Border.all(color: Colors.grey.shade300),
                            shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: FileImage(editProfileController.profileImage!),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            alignment: Alignment.center,
                            height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: appColor
                              ),
                              child: Icon(Icons.edit,color: whiteColor,size: 12,)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 13),

                textfield(
                  controller: editProfileController.firstNameController,
                  labelText: profileController.profileModel!.profileData.firstName,
                ),
                const SizedBox(height: 13),
                textfield(
                  controller: editProfileController.lastNameController,
                  labelText: profileController.profileModel!.profileData.lastName,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: button(text: "Update".tr, color: appColor,
                    onPress: (){
                    editProfileController.editProfileApi(context: context,
                        firstName: editProfileController.firstNameController.text == "" ? profileController.profileModel!.profileData.firstName : editProfileController.firstNameController.text,
                        lastName: editProfileController.lastNameController.text == "" ? profileController.profileModel!.profileData.lastName : editProfileController.lastNameController.text,
                    );
                    }
                  ),
                ),
              ],
            ),
          ),
        );
      },),
    );
  }
}
