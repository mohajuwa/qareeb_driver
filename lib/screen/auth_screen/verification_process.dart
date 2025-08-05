// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qareeb/screen/auth_screen/proof_add_screen.dart';
import '../../controller/add_document_controller.dart';
import '../../controller/info_detail_controller.dart';
import '../../controller/verification_check_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/common.dart';
import 'final_verification_screen.dart';

class VerificationProcessScreen extends StatefulWidget {
  const VerificationProcessScreen({super.key});

  @override
  State<VerificationProcessScreen> createState() =>
      _VerificationProcessScreenState();
}

class _VerificationProcessScreenState extends State<VerificationProcessScreen> {
  VerificationCheckController verificationCheckController = Get.put(
    VerificationCheckController(),
  );
  AddDocumentController addDocumentController = Get.put(
    AddDocumentController(),
  );

  @override
  void initState() {
    fun();
    super.initState();
  }

  fun() {
    verificationCheckController.verificationCheckApi(context: context).then((
      value,
    ) {
      setState(() {});
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: whiteColor,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_sharp, size: 20, color: blackColor),
        ),
        title: Text(
          "Verification Process".tr,
          style: TextStyle(
            color: blackColor,
            fontSize: 16,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
      ),
      bottomNavigationBar: GetBuilder<VerificationCheckController>(
        builder: (verificationCheckController) {
          return verificationCheckController.isLoading
              ? verificationCheckController
                          .verificationCheckModel!.uploadCheck ==
                      "1"
                  ? Container(
                      margin: const EdgeInsets.all(10),
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: button(
                        text: "SUBMIT".tr,
                        color: appColor,
                        onPress: () {
                          // Get.offAll(const FinalVerificationScreen());
                          // Get.offAll(const FinalVerificationScreen());
                          Get.to(const FinalVerificationScreen());
                        },
                      ),
                    )
                  : const SizedBox()
              : const SizedBox();
        },
      ),
      body: GetBuilder<VerificationCheckController>(
        builder: (verificationCheckController) {
          return verificationCheckController.isLoading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    stepWiseLiner(value: 1),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      width: Get.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xff4038FF),
                            const Color(0xff4038FF).withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Additional Information".tr,
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 20,
                              fontFamily: FontFamily.sofiaProBold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: Get.width / 1.5,
                            child: Text(
                              "Enter correct details/clear pictures of documents below for smooth verification"
                                  .tr,
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: 18,
                                fontFamily: FontFamily.sofiaProRegular,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 13, top: 20),
                      child: Text(
                        verificationCheckController
                                    .verificationCheckModel!.driverStatus ==
                                "1"
                            ? verificationCheckController
                                        .verificationCheckModel!.driverStatus ==
                                    "2"
                                ? "Completed".tr
                                : "Document".tr
                            : "Under Verification".tr,
                        style: TextStyle(
                          color: greyText,
                          fontSize: 18,
                          fontFamily: FontFamily.sofiaProRegular,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: RefreshIndicator(
                        color: appColor,
                        onRefresh: () {
                          return Future.delayed(const Duration(seconds: 2), () {
                            verificationCheckController.verificationCheckApi(
                              context: context,
                            );
                          });
                        },
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: verificationCheckController
                                    .verificationCheckModel!
                                    .documantList
                                    .length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 20),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        addDocumentController.isLoading = true;
                                      });
                                      verificationCheckController
                                                      .verificationCheckModel!
                                                      .documantList[index]
                                                      .status ==
                                                  "0" ||
                                              verificationCheckController
                                                      .verificationCheckModel!
                                                      .documantList[index]
                                                      .approve ==
                                                  "2"
                                          ? Get.to(
                                              ProofAddScreen(
                                                name:
                                                    verificationCheckController
                                                        .verificationCheckModel!
                                                        .documantList[index]
                                                        .name,
                                                imageSide:
                                                    verificationCheckController
                                                        .verificationCheckModel!
                                                        .documantList[index]
                                                        .requireImageSide,
                                                fieldName:
                                                    verificationCheckController
                                                        .verificationCheckModel!
                                                        .documantList[index]
                                                        .reqFieldName,
                                                inputFieldRequire:
                                                    verificationCheckController
                                                        .verificationCheckModel!
                                                        .documantList[index]
                                                        .inputRequire,
                                                docID:
                                                    verificationCheckController
                                                        .verificationCheckModel!
                                                        .documantList[index]
                                                        .id
                                                        .toString(),
                                              ),
                                            )
                                          : const SizedBox();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(14),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 13,
                                      ),
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        color: greyText.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                verificationCheckController
                                                    .verificationCheckModel!
                                                    .documantList[index]
                                                    .name,
                                                style: TextStyle(
                                                  color: blackColor,
                                                  fontSize: 16,
                                                  fontFamily: FontFamily
                                                      .sofiaProRegular,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              verificationCheckController
                                                              .verificationCheckModel!
                                                              .documantList[
                                                                  index]
                                                              .status ==
                                                          "1" &&
                                                      verificationCheckController
                                                              .verificationCheckModel!
                                                              .documantList[
                                                                  index]
                                                              .approve ==
                                                          "0"
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 5,
                                                      ),
                                                      child: Text(
                                                        "Verification Pending"
                                                            .tr,
                                                        style: const TextStyle(
                                                          color: Color(
                                                            0xffE68C00,
                                                          ),
                                                          fontSize: 12,
                                                          fontFamily: FontFamily
                                                              .sofiaProRegular,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    )
                                                  : verificationCheckController
                                                                  .verificationCheckModel!
                                                                  .documantList[
                                                                      index]
                                                                  .status ==
                                                              "1" &&
                                                          verificationCheckController
                                                                  .verificationCheckModel!
                                                                  .documantList[
                                                                      index]
                                                                  .approve ==
                                                              "1"
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 5,
                                                          ),
                                                          child: Text(
                                                            "Verification Complete"
                                                                .tr,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                0xff00D261,
                                                              ),
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  0.5,
                                                              fontFamily: FontFamily
                                                                  .sofiaProRegular,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                            ],
                                          ),
                                          verificationCheckController
                                                          .verificationCheckModel!
                                                          .documantList[index]
                                                          .status ==
                                                      "1" &&
                                                  verificationCheckController
                                                          .verificationCheckModel!
                                                          .documantList[index]
                                                          .approve ==
                                                      "0"
                                              ? SizedBox(
                                                  height: 33,
                                                  child: Image.asset(
                                                    'assets/image/info-circle.png',
                                                  ),
                                                )
                                              : verificationCheckController
                                                              .verificationCheckModel!
                                                              .documantList[
                                                                  index]
                                                              .status ==
                                                          "1" &&
                                                      verificationCheckController
                                                              .verificationCheckModel!
                                                              .documantList[
                                                                  index]
                                                              .approve ==
                                                          "1"
                                                  ? SizedBox(
                                                      height: 33,
                                                      child: Image.asset(
                                                        'assets/image/tick-circle.png',
                                                      ),
                                                    )
                                                  : Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: appColor,
                                                        border: Border.all(
                                                          color: appColor,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.arrow_forward,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator(color: appColor));
        },
      ),
    );
  }
}
