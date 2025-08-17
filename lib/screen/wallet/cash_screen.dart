// ignore_for_file: unused_import

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qareeb/screen/wallet/payout_request_screen.dart';
import '../../config/data_store.dart';
import '../../controller/add_cash_controller.dart';
import '../../controller/payout_wallet_controller.dart';
import '../../controller/total_cash_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/common.dart';
import '../../widget/dark_light_mode.dart';
import 'cash_history_screen.dart';

class CashScreen extends StatefulWidget {
  const CashScreen({super.key});

  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  @override
  void initState() {
    // walletDetailController.walletApi(context: context);
    getDarkMode();
    totalCashController.totalCashApi(context: context);
    super.initState();
  }

  get picker => ImagePicker();

  // WalletDetailController walletDetailController = Get.put(WalletDetailController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // PayoutWalletController payoutWalletController = Get.put(PayoutWalletController());
  List<String> BankType = ["Current Account", "Saving Account"];

  TotalCashController totalCashController = Get.put(TotalCashController());
  AddCashController addCashController = Get.put(AddCashController());

  List<String> payType = ["UPI", "BANK Transfer", "Paypal"];

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
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, size: 22, color: notifier.textColor),
        ),
        title: Text(
          "Transfer to Admin".tr,
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 18,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(const CashHistoryScreen());
            },
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 11),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: notifier.background,
                border: Border.all(color: appColor),
                borderRadius: BorderRadius.circular(45),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Cash History".tr,
                    style: TextStyle(
                      color: notifier.textColor,
                      fontSize: 12,
                      fontFamily: FontFamily.sofiaProBold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: GetBuilder<TotalCashController>(
        builder: (context) {
          return totalCashController.isLoading
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 15,
                        right: 15,
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Balance".tr,
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 15,
                                  fontFamily: FontFamily.sofiaProRegular,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${getData.read("Currency")}${totalCashController.totalCashModel!.totCash}",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 18,
                                  fontFamily: FontFamily.sofiaProBold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              requestSheet().then((value) {
                                addCashController.emptyDetails();
                                addCashController.galleryFileFront = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: appColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 35,
                                    width: 35,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_upward,
                                        color: blackColor,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    "Transfer to Admin".tr,
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 16,
                                      fontFamily: FontFamily.sofiaProBold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    totalCashController.totalCashModel!.cashData.isNotEmpty
                        ? Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 15),
                              margin: const EdgeInsets.only(
                                top: 15,
                                left: 15,
                                right: 15,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                color: notifier.containerColor,
                              ),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: totalCashController
                                          .totalCashModel!.cashData.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 30),
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            const SizedBox(height: 5),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: 1,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          25,
                                                        ),
                                                        color: notifier
                                                            .borderColor,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    totalCashController
                                                        .totalCashModel!
                                                        .cashData[index]
                                                        .date
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color: greyText2,
                                                      fontSize: 13,
                                                      letterSpacing: 0.5,
                                                      fontFamily: FontFamily
                                                          .sofiaProBold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Container(
                                                      height: 1,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          25,
                                                        ),
                                                        color: notifier
                                                            .borderColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              itemCount: totalCashController
                                                  .totalCashModel!
                                                  .cashData[index]
                                                  .detail
                                                  .length,
                                              itemBuilder: (context, index2) =>
                                                  Column(
                                                children: [
                                                  ListTile(
                                                    title: Text(
                                                      totalCashController
                                                                  .totalCashModel!
                                                                  .cashData[
                                                                      index]
                                                                  .detail[
                                                                      index2]
                                                                  .status ==
                                                              "1"
                                                          ? "SUCCESS"
                                                          : "PENDING",
                                                      style: TextStyle(
                                                        color: totalCashController
                                                                    .totalCashModel!
                                                                    .cashData[
                                                                        index]
                                                                    .detail[
                                                                        index2]
                                                                    .status ==
                                                                "1"
                                                            ? Colors
                                                                .green.shade600
                                                            : Colors.orange
                                                                .shade400,
                                                        fontSize: 16,
                                                        fontFamily: FontFamily
                                                            .sofiaProBold,
                                                      ),
                                                    ),
                                                    subtitle: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 4,
                                                      ),
                                                      child: Text(
                                                        "Ride ID: ${totalCashController.totalCashModel!.cashData[index].detail[index2].id}",
                                                        style: TextStyle(
                                                          color: greyText,
                                                          fontSize: 13,
                                                          fontFamily: FontFamily
                                                              .sofiaProBold,
                                                        ),
                                                      ),
                                                    ),
                                                    trailing: totalCashController
                                                                .totalCashModel!
                                                                .cashData[index]
                                                                .detail[index2]
                                                                .status ==
                                                            "1"
                                                        ? Text(
                                                            "${getData.read("Currency")} ${totalCashController.totalCashModel!.cashData[index].detail[index2].amount}",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .green
                                                                  .shade600,
                                                              fontSize: 17,
                                                              fontFamily: FontFamily
                                                                  .sofiaProBold,
                                                            ),
                                                          )
                                                        : Text(
                                                            "${getData.read("Currency")} ${totalCashController.totalCashModel!.cashData[index].detail[index2].amount}",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .orange
                                                                  .shade400,
                                                              fontSize: 17,
                                                              fontFamily: FontFamily
                                                                  .sofiaProBold,
                                                            ),
                                                          ),
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        25,
                                                      ),
                                                      color:
                                                          notifier.borderColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          "assets/image/emptyOrder.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "No Cash Found!".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.sofiaProBold,
                                      color: notifier.textColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Currently you don’t have cash.".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.sofiaProRegular,
                                      fontSize: 15,
                                      color: greyText,
                                    ),
                                  ),
                                ],
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

  bool isLoading = false;

  Future<void> requestSheet() {
    return Get.bottomSheet(
      isScrollControlled: true,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Form(
            key: _formKey,
            child: Container(
              width: Get.size.width,
              decoration: BoxDecoration(
                color: notifier.containerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      "Transfer to Admin".tr,
                      style: TextStyle(
                        color: notifier.textColor,
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    textfield(
                      controller: addCashController.cashAmountController,
                      labelText: "Amount".tr,
                      textInputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Amount'.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Select Type".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                          color: notifier.textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 60,
                      width: Get.size.width,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                        color: notifier.background,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: DropdownButton(
                        dropdownColor: notifier.background,
                        hint: Text(
                          "Select Type".tr,
                          style: TextStyle(color: Colors.grey),
                        ),
                        value: addCashController.selectType,
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20,
                          color: notifier.textColor,
                        ),
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        items: payType.map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyMedium,
                                color: notifier.textColor,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            addCashController.selectType = value ?? "";
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: notifier.background,
                      ),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        color: addCashController.galleryFileFront == null
                            ? greyText
                            : appColor,
                        radius: const Radius.circular(15),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isLoading = true; // Start loading
                            });

                            getImageFront(ImageSource.gallery, context)
                                .then((value) {
                              setState(() {
                                isLoading =
                                    false; // Stop loading after image is picked
                              });
                            }).catchError((error) {
                              setState(() {
                                isLoading = false; // Stop loading on error
                              });
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: appColor,
                                      ),
                                    ) // Show loader when loading
                                  : addCashController.galleryFileFront == null
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/image/uplodeimage.png",
                                              height: 40,
                                              width: 42,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "Upload",
                                              style: TextStyle(
                                                color: greyText,
                                                fontSize: 12,
                                                fontFamily:
                                                    FontFamily.sofiaProBold,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          height: 200,
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            image: DecorationImage(
                                              image: FileImage(
                                                addCashController
                                                    .galleryFileFront!,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    addCashController.isLoading
                        ? Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    addCashController.emptyDetails();
                                    Get.back();
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: const EdgeInsets.all(15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFeef4ff),
                                      borderRadius: BorderRadius.circular(45),
                                    ),
                                    child: Text(
                                      "Cancel".tr,
                                      style: TextStyle(
                                        color: appColor,
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      if (addCashController.selectType !=
                                          null) {
                                        addCashController.addCashApi(
                                          context: context,
                                        );
                                      } else {
                                        flutterToast(
                                          text: "Please Select Type".tr,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: const EdgeInsets.all(15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: appColor,
                                      borderRadius: BorderRadius.circular(45),
                                    ),
                                    child: Text(
                                      "Proceed".tr,
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: CircularProgressIndicator(color: appColor),
                          ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future getImageFront(ImageSource img, BuildContext context) async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      final pickedFile = await picker.pickImage(source: img);
      XFile? xFilePick = pickedFile;

      if (xFilePick != null) {
        addCashController.galleryFileFront = File(pickedFile!.path);
        addCashController.xFileImageFront = xFilePick;

        setState(() {
          isLoading = false; // Stop loading after successful image pick
        });
      } else {
        snackBar(context: context, text: "Nothing is Selected");
        setState(() {
          isLoading = false; // Stop loading if nothing is selected
        });
      }
    } catch (e) {
      snackBar(context: context, text: "Error occurred while selecting image");
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }
}
