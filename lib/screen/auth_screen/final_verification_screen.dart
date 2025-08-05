// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qareeb/screen/auth_screen/verification_process.dart';
import '../../bottom_navigation_bar.dart';
import '../../controller/document_status_controller.dart';
import '../../controller/verification_check_controller.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/common.dart';

class FinalVerificationScreen extends StatefulWidget {
  const FinalVerificationScreen({super.key});

  @override
  State<FinalVerificationScreen> createState() =>
      _FinalVerificationScreenState();
}

class _FinalVerificationScreenState extends State<FinalVerificationScreen> {
  VerificationCheckController verificationCheckController = Get.put(
    VerificationCheckController(),
  );
  DocumentStatusController documentStatusController = Get.put(
    DocumentStatusController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: whiteColor,
        leading: GestureDetector(
          onTap: () {
            // SystemNavigator.pop();
            verificationCheckController
                .verificationCheckApi(context: context)
                .then((value) {
              Get.back();
              setState(() {});
            });
          },
          child: Icon(Icons.close, size: 25, color: blackColor),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: button(
          text: "CONTINUE".tr,
          color: appColor,
          onPress: () {
            documentStatusController.documentStatusApi(context: context).then((
              value,
            ) {
              Map<String, dynamic> decodedValue = json.decode(value);
              print("+++++++++++++++ $decodedValue");

              if (decodedValue["Result"] == true) {
                if (decodedValue["account_status"] == "1" &&
                    decodedValue["document_status"] == "1") {
                  // initPlatformState();
                  Get.offAll(const BottomBarScreen());
                } else if (decodedValue["document_status"] == "4") {
                  Get.offAll(const VerificationProcessScreen());
                } else if (decodedValue["document_status"] == "5") {
                  snackBar(
                    context: context,
                    text: "Document Verification is Pending",
                  );
                } else if (decodedValue["account_status"] == "0") {
                  snackBar(context: context, text: "Account is unapproved");
                }
              }
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Get Approved to Drive with Ease".tr,
                style: TextStyle(
                  color: blackColor,
                  fontSize: 22,
                  fontFamily: FontFamily.sofiaProBold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Once all your details—mobile number, personal info, vehicle, and bank information—are submitted correctly, we’ll review them and get your account activated in no time!"
                    .tr,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontFamily: FontFamily.sofiaProRegular,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 25),
              containerData(
                image: "assets/image/personalinfo.json",
                title: "Personal Information".tr,
                subtitle:
                    "Provide your mobile number and basic personal details for identity verification."
                        .tr,
              ),
              const SizedBox(height: 10),
              containerData(
                image: "assets/image/vehicle.json",
                title: "Vehicle Information".tr,
                subtitle:
                    "Submit details like your vehicle’s make, model, year, and registration."
                        .tr,
              ),
              const SizedBox(height: 10),
              containerData(
                image: "assets/image/bank.json",
                title: "Documents".tr,
                subtitle:
                    "Enter your bank info for payments and upload required documents such as your driver’s license and insurance."
                        .tr,
              ),
              const SizedBox(height: 25),
              Text(
                "Once all information is correctly submitted, we’ll review it and activate your account quickly!"
                    .tr,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontFamily: FontFamily.sofiaProRegular,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget containerData({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(child: Lottie.asset(image, height: 100)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            title,
            style: TextStyle(
              color: blackColor,
              fontSize: 18,
              fontFamily: FontFamily.sofiaProBold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontFamily: FontFamily.sofiaProRegular,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
