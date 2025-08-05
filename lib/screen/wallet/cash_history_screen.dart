import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/data_store.dart';
import '../../controller/cash_detail_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/dark_light_mode.dart';

class CashHistoryScreen extends StatefulWidget {
  const CashHistoryScreen({super.key});

  @override
  State<CashHistoryScreen> createState() => _CashHistoryScreenState();
}

class _CashHistoryScreenState extends State<CashHistoryScreen> {

  CashDetailController cashDetailController = Get.put(CashDetailController());

  @override
  void initState() {
    getDarkMode();
    cashDetailController.cashDetailApi(context: context);
    super.initState();
  }

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
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back,size: 22,color: notifier.textColor),
        ),
        title: Text(
          "Cash History".tr,
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 18,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
      ),
      body: GetBuilder<CashDetailController>(
        builder: (cashDetailController) {
          return cashDetailController.isLoading
              ? Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Cash".tr,
                          style: TextStyle(
                            color: notifier.textColor,
                            fontSize: 15,
                            fontFamily: FontFamily.sofiaProRegular,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${getData.read("Currency")}${cashDetailController.cashDetailModel!.totCashAmount}",
                          style: TextStyle(
                            color: notifier.textColor,
                            fontSize: 18,
                            fontFamily: FontFamily.sofiaProBold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                    height: Get.height,
                    width: Get.width,
                    margin: const EdgeInsets.only(
                        top: 15, left: 15, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                      color: notifier.containerColor,
                    ),
                    child: cashDetailController.cashDetailModel!.walletData.isNotEmpty
                        ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                          ListView.separated(
                            shrinkWrap: true,
                            itemCount: cashDetailController.cashDetailModel!.walletData.length,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
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
                                              BorderRadius.circular(
                                                  25),
                                              color: notifier.borderColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          cashDetailController.cashDetailModel!.walletData[index].date.toUpperCase(),
                                          style: TextStyle(
                                            color: greyText2,
                                            fontSize: 13,
                                            letterSpacing: 0.5,
                                            fontFamily:
                                            FontFamily.sofiaProBold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                            height: 1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  25),
                                              color: notifier.borderColor,
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
                                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                                    itemCount: cashDetailController.cashDetailModel!.walletData[index].detail.length,
                                    itemBuilder: (context, index2) =>
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    cashDetailController.cashDetailModel!.walletData[index].detail[index2].status == "1" ? "Your Earning" : "Your Payout",
                                                    style: TextStyle(
                                                      color: notifier.textColor,
                                                      fontSize: 17,
                                                      fontFamily: FontFamily.sofiaProBold,
                                                    ),
                                                  ),
                                                  cashDetailController.cashDetailModel!.walletData[index].detail[index2].status == "1"
                                                      ? Text(
                                                    "+ ${getData.read("Currency")} ${cashDetailController.cashDetailModel!.walletData[index].detail[index2].amount}",
                                                    style: TextStyle(
                                                      color: Colors
                                                          .green.shade900,
                                                      fontSize: 17,
                                                      fontFamily: FontFamily
                                                          .sofiaProBold,
                                                    ),
                                                  )
                                                      : Text(
                                                    "- ${getData.read("Currency")} ${cashDetailController.cashDetailModel!.walletData[index].detail[index2].amount}",
                                                    style: TextStyle(
                                                      color: Colors
                                                          .red.shade900,
                                                      fontSize: 17,
                                                      fontFamily: FontFamily
                                                          .sofiaProBold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 7),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Admin Fees".tr,
                                                    style: TextStyle(
                                                      color: greyText,
                                                      fontSize: 13,
                                                      fontFamily: FontFamily.sofiaProBold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${getData.read("Currency")} ${cashDetailController.cashDetailModel!.walletData[index].detail[index2].platformFee}",
                                                    style: TextStyle(
                                                      color: notifier.textColor,
                                                      fontSize: 15,
                                                      fontFamily: FontFamily.sofiaProBold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 7),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Ride ID:".tr,
                                                    style: TextStyle(
                                                      color: greyText,
                                                      fontSize: 13,
                                                      fontFamily: FontFamily.sofiaProBold,
                                                    ),
                                                  ),
                                                  Text(
                                                    cashDetailController.cashDetailModel!.walletData[index].detail[index2].paymentId,
                                                    style: TextStyle(
                                                      color: greyText,
                                                      fontSize: 13,
                                                      fontFamily: FontFamily.sofiaProBold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              cashDetailController.cashDetailModel!.walletData[index].detail[index2].paidAmount == "0"
                                                  ? const SizedBox()
                                                  : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 7),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${cashDetailController.cashDetailModel!.walletData[index].detail[index2].pName}:",
                                                        style: TextStyle(
                                                          color: greyText,
                                                          fontSize: 13,
                                                          fontFamily: FontFamily.sofiaProBold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${getData.read("Currency")} ${cashDetailController.cashDetailModel!.walletData[index].detail[index2].paidAmount}",
                                                        style: TextStyle(
                                                          color: greyText,
                                                          fontSize: 13,
                                                          fontFamily: FontFamily.sofiaProBold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),

                                              cashDetailController.cashDetailModel!.walletData[index].detail[index2].walletPrice == "0"
                                                  ? const SizedBox()

                                                  : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 7),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Wallet:".tr,
                                                        style: TextStyle(
                                                          color: greyText,
                                                          fontSize: 13,
                                                          fontFamily: FontFamily.sofiaProBold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${getData.read("Currency")} ${cashDetailController.cashDetailModel!.walletData[index].detail[index2].walletPrice}",
                                                        style: TextStyle(
                                                          color: greyText,
                                                          fontSize: 13,
                                                          fontFamily: FontFamily.sofiaProBold,
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
                                                  BorderRadius.circular(
                                                      25),
                                                  color: notifier.borderColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  )
                                ],
                              );
                            },
                          ),
                                                ],
                                              ),
                        )
                        : Center(
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
                                    "assets/image/emptyOrder.png"),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "No Payout Found!".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.sofiaProBold,
                              color: notifier.textColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Currently you don’t have payout.".tr,
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
              ),
            ],
          )
              : Center(child: CircularProgressIndicator(color: appColor));
        }
      ),
    );
  }
}
