import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qareeb/screen/wallet/cash_screen.dart';
import 'package:qareeb/screen/wallet/payout_request_screen.dart';
import '../../config/data_store.dart';
import '../../controller/payout_wallet_controller.dart';
import '../../controller/wallet_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/common.dart';
import '../../widget/dark_light_mode.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    getDarkMode();
    walletDetailController.walletApi(context: context);
    super.initState();
  }

  WalletDetailController walletDetailController = Get.put(
    WalletDetailController(),
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PayoutWalletController payoutWalletController = Get.put(
    PayoutWalletController(),
  );
  List<String> BankType = ["Current Account", "Saving Account"];

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
        title: Text(
          "My Wallet".tr,
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 18,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(const PayoutRequestScreen());
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
                    "Payout History".tr,
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
      body: GetBuilder<WalletDetailController>(
        builder: (context) {
          return walletDetailController.isLoading
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
                                "${getData.read("Currency")}${walletDetailController.walletDetailModel!.walletAmount}",
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
                                payoutWalletController.emptyDetails();
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
                                      child: SizedBox(
                                        height: 23,
                                        child: Image.asset(
                                          "assets/image/withdraw.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    "Withdraw".tr,
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
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Get.to(const CashScreen());
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
                                      child: SizedBox(
                                        height: 23,
                                        child: Image.asset(
                                          "assets/image/cash.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    "Cash".tr,
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
                    walletDetailController
                            .walletDetailModel!.walletData.isNotEmpty
                        ? Expanded(
                            child: Container(
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: walletDetailController
                                          .walletDetailModel!.walletData.length,
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
                                                    walletDetailController
                                                        .walletDetailModel!
                                                        .walletData[index]
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
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(
                                                height: 20,
                                              ),
                                              itemCount: walletDetailController
                                                  .walletDetailModel!
                                                  .walletData[index]
                                                  .detail
                                                  .length,
                                              itemBuilder: (context, index2) =>
                                                  Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          walletDetailController
                                                                      .walletDetailModel!
                                                                      .walletData[
                                                                          index]
                                                                      .detail[
                                                                          index2]
                                                                      .status ==
                                                                  "1"
                                                              ? "Your Earning"
                                                              : "Your Payout",
                                                          style: TextStyle(
                                                            color: notifier
                                                                .textColor,
                                                            fontSize: 17,
                                                            fontFamily: FontFamily
                                                                .sofiaProBold,
                                                          ),
                                                        ),
                                                        walletDetailController
                                                                    .walletDetailModel!
                                                                    .walletData[
                                                                        index]
                                                                    .detail[
                                                                        index2]
                                                                    .status ==
                                                                "1"
                                                            ? Text(
                                                                "+ ${getData.read("Currency")} ${walletDetailController.walletDetailModel!.walletData[index].detail[index2].amount}",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green
                                                                      .shade900,
                                                                  fontSize: 17,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .sofiaProBold,
                                                                ),
                                                              )
                                                            : Text(
                                                                "- ${getData.read("Currency")} ${walletDetailController.walletDetailModel!.walletData[index].detail[index2].amount}",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red
                                                                      .shade900,
                                                                  fontSize: 17,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .sofiaProBold,
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 7),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Admin Fees",
                                                          style: TextStyle(
                                                            color: greyText,
                                                            fontSize: 13,
                                                            fontFamily: FontFamily
                                                                .sofiaProBold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${getData.read("Currency")} ${walletDetailController.walletDetailModel!.walletData[index].detail[index2].platformFee}",
                                                          style: TextStyle(
                                                            color: notifier
                                                                .textColor,
                                                            fontSize: 15,
                                                            fontFamily: FontFamily
                                                                .sofiaProBold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 7),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Ride ID:",
                                                          style: TextStyle(
                                                            color: greyText,
                                                            fontSize: 13,
                                                            fontFamily: FontFamily
                                                                .sofiaProBold,
                                                          ),
                                                        ),
                                                        Text(
                                                          walletDetailController
                                                              .walletDetailModel!
                                                              .walletData[index]
                                                              .detail[index2]
                                                              .paymentId,
                                                          style: TextStyle(
                                                            color: greyText,
                                                            fontSize: 13,
                                                            fontFamily: FontFamily
                                                                .sofiaProBold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    walletDetailController
                                                                .walletDetailModel!
                                                                .walletData[
                                                                    index]
                                                                .detail[index2]
                                                                .paidAmount ==
                                                            "0"
                                                        ? const SizedBox()
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                height: 7,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "${walletDetailController.walletDetailModel!.walletData[index].detail[index2].pName}:",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          greyText,
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .sofiaProBold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${getData.read("Currency")} ${walletDetailController.walletDetailModel!.walletData[index].detail[index2].paidAmount}",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          greyText,
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .sofiaProBold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                    walletDetailController
                                                                .walletDetailModel!
                                                                .walletData[
                                                                    index]
                                                                .detail[index2]
                                                                .walletPrice ==
                                                            "0"
                                                        ? const SizedBox()
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                height: 7,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Wallet:",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          greyText,
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .sofiaProBold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${getData.read("Currency")} ${walletDetailController.walletDetailModel!.walletData[index].detail[index2].walletPrice}",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          greyText,
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .sofiaProBold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                    const SizedBox(height: 10),
                                                    Container(
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
                                                  ],
                                                ),
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
                                    "No Wallet Found!".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.sofiaProBold,
                                      color: notifier.textColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Currently you don’t have wallet.".tr,
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
                      "Payout Request".tr,
                      style: TextStyle(
                        color: notifier.textColor,
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Withdraw amount:".tr,
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontFamily: FontFamily.gilroyBold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "${getData.read("Currency")}${walletDetailController.walletDetailModel!.withdrawAmount}",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontFamily: FontFamily.gilroyBold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Minimum amount:".tr,
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontFamily: FontFamily.gilroyBold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "${getData.read("Currency")}${walletDetailController.walletDetailModel!.minimumWiAmount}",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontFamily: FontFamily.gilroyBold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    textfield(
                      controller: payoutWalletController.payoutAmountController,
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
                          style: const TextStyle(color: Colors.grey),
                        ),
                        value: payoutWalletController.selectType,
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
                            payoutWalletController.selectType = value ?? "";
                          });
                        },
                      ),
                    ),
                    payoutWalletController.selectType == "UPI"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "UPI".tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 16,
                                    color: notifier.textColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              textfield(
                                controller:
                                    payoutWalletController.payoutUpiController,
                                labelText: "UPI".tr,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter UPI'.tr;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : payoutWalletController.selectType == "BANK Transfer"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      "Account Number".tr,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 16,
                                        color: notifier.textColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  textfield(
                                    controller: payoutWalletController
                                        .payoutAccountNumberController,
                                    labelText: "Account Number".tr,
                                    textInputType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Account Number'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      "IFSC Code".tr,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 16,
                                        color: notifier.textColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  textfield(
                                    controller:
                                        payoutWalletController.ifscController,
                                    labelText: "IFSC Code".tr,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter IFSC Code'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      "Bank Type".tr,
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
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: notifier.background,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    child: DropdownButton(
                                      dropdownColor: notifier.background,
                                      hint: Text(
                                        "Bank Type".tr,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      value: payoutWalletController.bankType,
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        size: 20,
                                        color: notifier.textColor,
                                      ),
                                      isExpanded: true,
                                      underline: const SizedBox.shrink(),
                                      items: BankType.map<
                                          DropdownMenuItem<String>>(
                                        (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyMedium,
                                                color: notifier.textColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          payoutWalletController.bankType =
                                              value ?? "";
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : payoutWalletController.selectType == "Paypal"
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          "Email ID".tr,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyBold,
                                            fontSize: 16,
                                            color: notifier.textColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      textfield(
                                        controller: payoutWalletController
                                            .emailIdController,
                                        labelText: "Email Id".tr,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Paypal id'.tr;
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  )
                                : Container(),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              payoutWalletController.emptyDetails();
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
                              if (_formKey.currentState?.validate() ?? false) {
                                if (payoutWalletController.selectType != null) {
                                  payoutWalletController.payoutApi(
                                    context: context,
                                  );
                                } else {
                                  snackBar(
                                    context: context,
                                    text: "Please Select Type",
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
}
