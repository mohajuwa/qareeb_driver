import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qareeb/config/config.dart';
import '../../config/data_store.dart';
import '../../controller/payout_detail_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/dark_light_mode.dart';

class PayoutRequestScreen extends StatefulWidget {
  const PayoutRequestScreen({super.key});

  @override
  State<PayoutRequestScreen> createState() => _PayoutRequestScreenState();
}

class _PayoutRequestScreenState extends State<PayoutRequestScreen> {
  PayoutDetailController payoutDetailController = Get.put(
    PayoutDetailController(),
  );

  @override
  void initState() {
    getDarkMode();
    payoutDetailController.payoutDetailApi(context: context);
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
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, size: 22, color: notifier.textColor),
        ),
        title: Text(
          "Payout".tr,
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 18,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
      ),
      body: GetBuilder<PayoutDetailController>(
        builder: (context) {
          return payoutDetailController.isLoading
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
                                "Total Payout",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 15,
                                  fontFamily: FontFamily.sofiaProRegular,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${getData.read("Currency")}${payoutDetailController.payoutDetailModel!.totPayout}",
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
                        child: payoutDetailController
                                .payoutDetailModel!.payoutData.isNotEmpty
                            ? SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: payoutDetailController
                                          .payoutDetailModel!.payoutData.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: notifier.borderColor,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return detailBottom(index);
                                                },
                                              );
                                            },
                                            leading: payoutDetailController
                                                        .payoutDetailModel!
                                                        .payoutData[index]
                                                        .status ==
                                                    "1"
                                                ? Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: notifier
                                                            .borderColor,
                                                      ),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        65,
                                                      ),
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                        placeholder:
                                                            "assets/image/ezgif.com-crop.gif",
                                                        placeholderCacheWidth:
                                                            50,
                                                        placeholderCacheHeight:
                                                            50,
                                                        image:
                                                            "${Config.imageUrl}${payoutDetailController.payoutDetailModel!.payoutData[index].image}",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 50,
                                                    width: 50,
                                                    padding:
                                                        const EdgeInsets.all(
                                                      12,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors
                                                          .orange.shade100,
                                                    ),
                                                    child: Image.asset(
                                                      "assets/image/wallet.png",
                                                      color: Colors
                                                          .orange.shade600,
                                                    ),
                                                  ),
                                            title: Text(
                                              payoutDetailController
                                                  .payoutDetailModel!
                                                  .payoutData[index]
                                                  .date
                                                  .toString()
                                                  .split(" ")
                                                  .first,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: notifier.textColor,
                                                fontFamily:
                                                    FontFamily.gilroyBold,
                                                // fontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            subtitle: payoutDetailController
                                                        .payoutDetailModel!
                                                        .payoutData[index]
                                                        .status ==
                                                    "1"
                                                ? Text(
                                                    "Completed",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                : Text(
                                                    "Pending",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: Colors
                                                          .orange.shade600,
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                            trailing: payoutDetailController
                                                        .payoutDetailModel!
                                                        .payoutData[index]
                                                        .status ==
                                                    "1"
                                                ? Text(
                                                    "${getData.read("Currency")}${payoutDetailController.payoutDetailModel!.payoutData[index].amount}",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                    ),
                                                  )
                                                : Text(
                                                    "${getData.read("Currency")}${payoutDetailController.payoutDetailModel!.payoutData[index].amount}",
                                                    style: TextStyle(
                                                      color: Colors
                                                          .orange.shade600,
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                    ),
                                                  ),
                                          ),
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
                                            "assets/image/emptyOrder.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "No Payout Found!".tr,
                                      style: TextStyle(
                                        fontFamily: FontFamily.sofiaProBold,
                                        color: notifier.textColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
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
        },
      ),
    );
  }

  Widget detailBottom(index) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(12),
      actionsPadding: EdgeInsets.zero,
      backgroundColor: notifier.background,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ID : #${payoutDetailController.payoutDetailModel!.payoutData[index].id}",
                style: TextStyle(
                  color: notifier.textColor,
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 15,
                ),
              ),
              payoutDetailController
                          .payoutDetailModel!.payoutData[index].status ==
                      "1"
                  ? Text(
                      "Completed".tr,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: FontFamily.gilroyBold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Text(
                      "Pending".tr,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.orange.shade600,
                        fontFamily: FontFamily.gilroyBold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 10),
          payoutDetailController.payoutDetailModel!.payoutData[index].status ==
                  "1"
              ? Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      // borderRadius: BorderRadius.circular(65),
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/image/ezgif.com-crop.gif",
                        placeholderCacheWidth: 50,
                        placeholderCacheHeight: 50,
                        image:
                            "${Config.imageUrl}${payoutDetailController.payoutDetailModel!.payoutData[index].image}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange.shade100,
                    ),
                    child: Image.asset(
                      "assets/image/wallet.png",
                      color: Colors.orange.shade600,
                    ),
                  ),
                ),
          const SizedBox(height: 10),
          orderInfo(
            title: "Date".tr,
            subtitle: payoutDetailController
                .payoutDetailModel!.payoutData[index].date,
          ),
          const SizedBox(height: 5),
          orderInfo(
            title: "Amount".tr,
            subtitle:
                "${getData.read("Currency")}${payoutDetailController.payoutDetailModel!.payoutData[index].amount}",
          ),
          const SizedBox(height: 5),
          payoutDetailController.payoutDetailModel!.payoutData[index].pType ==
                  "1"
              ? orderInfo(
                  title: "UPI ID".tr,
                  subtitle: payoutDetailController
                      .payoutDetailModel!.payoutData[index].upiId,
                )
              : payoutDetailController
                          .payoutDetailModel!.payoutData[index].pType ==
                      "2"
                  ? orderInfo(
                      title: "Paypal ID".tr,
                      subtitle: payoutDetailController
                          .payoutDetailModel!.payoutData[index].paypalId,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderInfo(
                          title: "Account Number".tr,
                          subtitle: payoutDetailController
                              .payoutDetailModel!.payoutData[index].bankNo,
                        ),
                        const SizedBox(height: 5),
                        orderInfo(
                          title: "Bank Ifsc".tr,
                          subtitle: payoutDetailController
                              .payoutDetailModel!.payoutData[index].bankIfsc,
                        ),
                        const SizedBox(height: 5),
                        orderInfo(
                          title: "Bank Type".tr,
                          subtitle: payoutDetailController
                              .payoutDetailModel!.payoutData[index].bankType,
                        ),
                      ],
                    ),
        ],
      ),
    );
  }

  orderInfo({String? title, subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title ?? "",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 13,
            color: greyText,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          ":",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 13,
            color: greyText,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          subtitle ?? "",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
