// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qareeb/config/data_store.dart';
import 'package:qareeb/widget/common.dart';
import '../../bottom_navigation_bar.dart';
import '../../controller/complete_price_controller.dart';
import '../../controller/past_detail_controller.dart';
import '../../controller/rate_review_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/dark_light_mode.dart';

class PastDetailScreen extends StatefulWidget {
  final String requestId;
  const PastDetailScreen({super.key, required this.requestId});

  @override
  State<PastDetailScreen> createState() => _PastDetailScreenState();
}

class _PastDetailScreenState extends State<PastDetailScreen> {
  @override
  void initState() {
    getDarkMode();
    rideHistoryDetailController.isLoading = false;
    rideHistoryDetailController.rideHistoryDetailApi(
      context: context,
      requestId: widget.requestId.toString(),
    );
    super.initState();
  }

  RideHistoryDetailController rideHistoryDetailController = Get.put(
    RideHistoryDetailController(),
  );
  RateReviewController rateReviewController = Get.put(RateReviewController());

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
        // centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: notifier.textColor),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "#${widget.requestId}",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 19,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
      ),
      body: GetBuilder<RideHistoryDetailController>(
        builder: (context) {
          return rideHistoryDetailController.isLoading
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        padding: const EdgeInsets.all(10),
                        color: notifier.containerColor,
                        child: Column(
                          children: [
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: notifier.containerColor,
                                border: Border.all(color: notifier.borderColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "PICKUP & DESTINATION".tr,
                                      style: TextStyle(
                                        color: appColor,
                                        fontSize: 13.5,
                                        letterSpacing: 0.5,
                                        fontFamily: FontFamily.sofiaProBold,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 5),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade50,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Container(
                                                height: 10,
                                                width: 10,
                                                margin: const EdgeInsets.all(6),
                                                decoration: const BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: notifier.borderColor,
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade50,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Container(
                                                height: 10,
                                                width: 10,
                                                margin: const EdgeInsets.all(6),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Started : ${rideHistoryDetailController.rideHistoryDetailModel!.historyData.picAddress.time}",
                                                style: TextStyle(
                                                  color: notifier.textColor,
                                                  fontSize: 13.5,
                                                  fontFamily:
                                                      FontFamily.sofiaProBold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                "${rideHistoryDetailController.rideHistoryDetailModel!.historyData.picAddress.title}, ${rideHistoryDetailController.rideHistoryDetailModel!.historyData.picAddress.subtitle}",
                                                style: TextStyle(
                                                  color: notifier.textColor,
                                                  fontSize: 13.5,
                                                  fontFamily: FontFamily
                                                      .sofiaProRegular,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 50),
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemCount:
                                                    rideHistoryDetailController
                                                        .rideHistoryDetailModel!
                                                        .historyData
                                                        .dropAddress
                                                        .length,
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const SizedBox(
                                                  height: 15,
                                                ),
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Ended : ${rideHistoryDetailController.rideHistoryDetailModel!.historyData.dropAddress[index].time}",
                                                        style: TextStyle(
                                                          color: notifier
                                                              .textColor,
                                                          fontSize: 13.5,
                                                          fontFamily: FontFamily
                                                              .sofiaProBold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Text(
                                                        "${rideHistoryDetailController.rideHistoryDetailModel!.historyData.dropAddress[index].title}, ${rideHistoryDetailController.rideHistoryDetailModel!.historyData.dropAddress[index].subtitle}",
                                                        style: TextStyle(
                                                          color: notifier
                                                              .textColor,
                                                          fontSize: 13.5,
                                                          fontFamily: FontFamily
                                                              .sofiaProRegular,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: notifier.containerColor,
                                border: Border.all(color: notifier.borderColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "BASIC DETAILS".tr,
                                      style: TextStyle(
                                        color: appColor,
                                        fontSize: 13.5,
                                        letterSpacing: 0.5,
                                        fontFamily: FontFamily.sofiaProBold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    data(
                                      title: "Trip ID:".tr,
                                      value: "#${widget.requestId}",
                                    ),
                                    data(
                                      title: "Trip Distance:".tr,
                                      value:
                                          "${rideHistoryDetailController.rideHistoryDetailModel!.historyData.totKm} Km",
                                    ),
                                    data(
                                      title: "Trip Duration:".tr,
                                      value:
                                          "${rideHistoryDetailController.rideHistoryDetailModel!.historyData.totMinute} Hrs",
                                    ),
                                    data(
                                      title: "Vehicle Type:".tr,
                                      value: rideHistoryDetailController
                                          .rideHistoryDetailModel!
                                          .historyData
                                          .vehicleName,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: notifier.containerColor,
                                border: Border.all(color: notifier.borderColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ESTIMATED FARE DETAILS".tr,
                                      style: TextStyle(
                                        color: appColor,
                                        fontSize: 13.5,
                                        letterSpacing: 0.5,
                                        fontFamily: FontFamily.sofiaProBold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    data(
                                      title: "Estimated Total Fare:".tr,
                                      value:
                                          "${getData.read("Currency")}${rideHistoryDetailController.rideHistoryDetailModel!.historyData.finalPrice}",
                                    ),
                                    const SizedBox(height: 15),
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: notifier.borderColor,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Center(
                                      child: Text(
                                        "Earned money from trip:".tr,
                                        style: TextStyle(
                                          color: appColor,
                                          fontSize: 15,
                                          fontFamily:
                                              FontFamily.sofiaProRegular,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Center(
                                      child: Text(
                                        "${getData.read("Currency")}${rideHistoryDetailController.rideHistoryDetailModel!.historyData.price}",
                                        style: TextStyle(
                                          color: appColor,
                                          fontSize: 20,
                                          fontFamily: FontFamily.sofiaProBold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator(color: appColor));
        },
      ),
      floatingActionButton: GetBuilder<RideHistoryDetailController>(
        builder: (context) {
          return rideHistoryDetailController.isLoading
              ? rideHistoryDetailController
                          .rideHistoryDetailModel!.historyData.reviewCheck ==
                      0
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: button(
                        text: "Review".tr,
                        color: appColor,
                        onPress: () {
                          rateBottomSheet(
                            cId: rideHistoryDetailController
                                .rideHistoryDetailModel!.historyData.cId,
                          );
                        },
                      ),
                    )
                  : const SizedBox()
              : const SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget data({required String title, required String value}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: VisualDensity.compact,
      minVerticalPadding: 0,
      title: Text(
        title,
        style: TextStyle(
          color: notifier.textColor,
          fontSize: 15,
          fontFamily: FontFamily.sofiaProRegular,
        ),
      ),
      trailing: Text(
        value,
        style: TextStyle(
          color: notifier.textColor,
          fontSize: 15,
          fontFamily: FontFamily.sofiaProRegular,
        ),
      ),
    );
  }

  Future rateBottomSheet({required String cId}) {
    return Get.bottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      StatefulBuilder(
        builder: (context, setState) {
          return Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notifier.background,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/image/tick-circle.png",
                              scale: 3.2,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Paid ${getData.read("Currency")}${rideHistoryDetailController.rideHistoryDetailModel!.historyData.finalPrice}",
                              style: TextStyle(
                                fontFamily: FontFamily.sofiaProBold,
                                fontSize: 15,
                                // fontWeight: FontWeight.w500,
                                color: notifier.textColor,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: notifier.background,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.help_outline,
                                    size: 21,
                                    color: notifier.textColor,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    "Help".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.sofiaProBold,
                                      fontSize: 14,
                                      color: notifier.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: appColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              rideHistoryDetailController
                                  .rideHistoryDetailModel!
                                  .historyData
                                  .cusName[0]
                                  .toUpperCase(),
                              style: TextStyle(
                                fontFamily: FontFamily.sofiaProBold,
                                fontSize: 23,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "How was your ride with ${rideHistoryDetailController.rideHistoryDetailModel!.historyData.cusName}",
                          style: TextStyle(
                            fontFamily: FontFamily.sofiaProBold,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: notifier.textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        RatingBar(
                          initialRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          allowHalfRating: true,
                          ratingWidget: RatingWidget(
                            full: Image.asset(
                              'assets/image/starBold.png',
                              color: appColor,
                            ),
                            half: Image.asset(
                              'assets/image/star-half.png',
                              color: appColor,
                            ),
                            empty: Image.asset(
                              'assets/image/star.png',
                              color: appColor,
                            ),
                          ),
                          itemPadding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          onRatingUpdate: (rating) {
                            rateReviewController.totalRateUpdate(rating);
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Great, what did you like the most? 😍".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.sofiaProBold,
                            fontSize: 14,
                            color: greyText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: rideHistoryDetailController
                              .rideHistoryDetailModel!
                              .historyData
                              .reviewList
                              .length,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 48,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (rateReviewController.reviewList.contains(
                                    rideHistoryDetailController
                                        .rideHistoryDetailModel!.historyData
                                      ..reviewList[index].id,
                                  )) {
                                    rateReviewController.reviewList.remove(
                                      rideHistoryDetailController
                                          .rideHistoryDetailModel!
                                          .historyData
                                          .reviewList[index]
                                          .id,
                                    );
                                    print(
                                      "-------remove--------- ${rateReviewController.reviewList}",
                                    );
                                  } else {
                                    rateReviewController.reviewList.add(
                                      rideHistoryDetailController
                                          .rideHistoryDetailModel!
                                          .historyData
                                          .reviewList[index]
                                          .id,
                                    );
                                    print(
                                      "+++++++Add+++++++ ${rateReviewController.reviewList}",
                                    );
                                  }
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      rateReviewController.reviewList.contains(
                                    rideHistoryDetailController
                                        .rideHistoryDetailModel!
                                        .historyData
                                        .reviewList[index]
                                        .id,
                                  )
                                          ? appColor
                                          : notifier.containerColor,
                                  borderRadius: BorderRadius.circular(35),
                                  border: Border.all(
                                    color: rateReviewController.reviewList
                                            .contains(
                                      rideHistoryDetailController
                                          .rideHistoryDetailModel!
                                          .historyData
                                          .reviewList[index]
                                          .id,
                                    )
                                        ? appColor
                                        : Colors.grey.shade200,
                                  ),
                                ),
                                child: Text(
                                  rideHistoryDetailController
                                      .rideHistoryDetailModel!
                                      .historyData
                                      .reviewList[index]
                                      .title,
                                  style: TextStyle(
                                    fontFamily: FontFamily.sofiaProBold,
                                    fontSize: 13,
                                    color: rateReviewController.reviewList
                                            .contains(
                                      rideHistoryDetailController
                                          .rideHistoryDetailModel!
                                          .historyData
                                          .reviewList[index]
                                          .id,
                                    )
                                        ? whiteColor
                                        : notifier.textColor,
                                    letterSpacing: 0.3,
                                  ),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        textfield(
                          controller: rateReviewController.reviewController,
                          label: "Tell us more...".tr,
                        ),
                        const SizedBox(height: 20),
                        button(
                          text: "Done".tr,
                          color: appColor,
                          onPress: () {
                            rateReviewController.rateReviewAPi(
                              context: context,
                              requestId: widget.requestId.toString(),
                              cID: cId.toString(),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        button3(
                          text: "Skip".tr,
                          textColor: notifier.textColor,
                          color: Colors.transparent,
                          borderColor: appColor,
                          onPress: () {
                            setState(() {
                              Get.back();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
