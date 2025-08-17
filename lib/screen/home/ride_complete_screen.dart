// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qareeb/config/config.dart';
import 'package:qareeb/utils/colors.dart';
import 'package:qareeb/widget/common.dart';
import '../../bottom_navigation_bar.dart';
import '../../config/data_store.dart';
import '../../controller/check_vehicle_request_controller.dart';
import '../../controller/complete_price_controller.dart';
import '../../controller/rate_review_controller.dart';
import '../../utils/font_family.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:timeline_tile/timeline_tile.dart';

import '../../widget/dark_light_mode.dart';

class RideCompleteScreen extends StatefulWidget {
  final String requestId;
  final String cID;
  final String status;
  const RideCompleteScreen({
    super.key,
    required this.requestId,
    required this.cID,
    required this.status,
  });

  @override
  State<RideCompleteScreen> createState() => _RideCompleteScreenState();
}

int buttonStatus = 0;

class _RideCompleteScreenState extends State<RideCompleteScreen> {
  bool customTileExpanded = false;

  late IO.Socket socket;

  CompletePriceController completePriceController = Get.put(
    CompletePriceController(),
  );
  RateReviewController rateReviewController = Get.put(RateReviewController());

  @override
  void initState() {
    getDarkMode();
    socketConnect();
    super.initState();
  }

  socketConnect() async {
    socket = IO.io(Config.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    _connectSocket();
    completePriceController.priceDetailAPi(
      context: context,
      requestId: widget.requestId.toString(),
      cID: widget.cID.toString(),
    );
  }

  _connectSocket() {
    // socket.close();

    socket.off("Vehicle_P_Change${getData.read("UserLogin")['id']}");
    socket.off("Vehicle_Ride_Complete${getData.read("UserLogin")['id']}");

    socket.onConnect((data) => print('Connection established'));
    socket.onConnectError((data) => print('Connect Error: $data'));
    socket.onDisconnect((data) => print('Socket.IO server disconnected'));

    socket.on("Vehicle_P_Change${getData.read("UserLogin")['id']}", (status) {
      print('****status****-------- ${status}');
      completePriceController.priceDetailAPi(
        context: context,
        requestId: widget.requestId.toString(),
        cID: widget.cID.toString(),
      );
    });

    socket.on("Vehicle_Ride_Complete${getData.read("UserLogin")['id']}", (
      data,
    ) {
      print('****data****-------- ${data}');

      // completePriceController.priceDetailAPi(context: context, requestId: widget.requestId.toString(),cID: widget.cID.toString());
      buttonStatus = 1;
      print("****buttonStatus*********************-------- $buttonStatus");
      flutterToast(text: "Payment done Successfully");
      rateRequestID = data["request_id"].toString();
      rateBottomSheet(newRequestId: data["request_id"].toString());
      setState(() {});
    });
  }

  int timeLine = 0;

  String rateRequestID = "";

  CheckVehicleRequestController checkVehicleRequestController = Get.put(
    CheckVehicleRequestController(),
  );

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
  void dispose() {
    socket.off("Vehicle_P_Change${getData.read("UserLogin")['id']}");
    socket.off("Vehicle_Ride_Complete${getData.read("UserLogin")['id']}");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: notifier.containerColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                checkVehicleRequestController
                    .checkVehicleApi(
                  uid: getData.read("UserLogin")["id"].toString(),
                )
                    .then((value) {
                  currentIndexBottom = 0;
                  setState(() {});
                  socket.close();
                  Get.offAll(const BottomBarScreen());
                });
              },
              child: Icon(
                Icons.arrow_back,
                size: 20,
                color: notifier.textColor,
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<CompletePriceController>(
        builder: (completePriceController) {
          return completePriceController.isLoading
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: notifier.containerColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: completePriceController
                                .completePriceModel!.addCalculate.length,
                            itemBuilder: (context, index) {
                              return TimelineTile(
                                alignment: TimelineAlign.manual,
                                lineXY: 0.05,
                                isFirst: index == 0,
                                isLast: index ==
                                    completePriceController.completePriceModel!
                                            .addCalculate.length -
                                        1,
                                indicatorStyle: IndicatorStyle(
                                  width: 20,
                                  color: index == 0
                                      ? appColor
                                      : (index == 1
                                          ? Colors.red
                                          : Colors.green),
                                  indicatorXY: 0.25,
                                ),
                                beforeLineStyle: LineStyle(
                                  color: appColor,
                                  thickness: 2,
                                ),
                                afterLineStyle: LineStyle(
                                  color: appColor,
                                  thickness: 2,
                                ),
                                endChild: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 15,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${completePriceController.completePriceModel!.addCalculate[index].title} ${completePriceController.completePriceModel!.addCalculate[index].subtitle}",
                                        style: TextStyle(
                                          fontFamily:
                                              FontFamily.sofiaProRegular,
                                          fontSize: 14,
                                          color: greyText,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      index ==
                                              completePriceController
                                                      .completePriceModel!
                                                      .addCalculate
                                                      .length -
                                                  1
                                          ? const SizedBox()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 12),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .location_solid,
                                                      size: 20,
                                                      color: greyText,
                                                    ),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      "${completePriceController.completePriceModel!.addCalculate[index].totKm} km",
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .sofiaProRegular,
                                                        fontSize: 15,
                                                        color:
                                                            notifier.textColor,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Icon(
                                                      CupertinoIcons.time,
                                                      size: 20,
                                                      color: greyText,
                                                    ),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      "${completePriceController.completePriceModel!.addCalculate[index].totTime} min",
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .sofiaProRegular,
                                                        fontSize: 15,
                                                        color:
                                                            notifier.textColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: notifier.containerColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
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
                                    completePriceController.completePriceModel!
                                        .priceList.cusName[0]
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
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: notifier.background,
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      child: Image.asset(
                                        "assets/image/tick-circle.png",
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "RIDE COMPLETED".tr,
                                      style: TextStyle(
                                        fontFamily: FontFamily.sofiaProRegular,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 13),
                              Text(
                                "Select a payment method to pay".tr,
                                style: TextStyle(
                                  fontFamily: FontFamily.sofiaProBold,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: notifier.textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                completePriceController
                                    .completePriceModel!.priceList.cusName,
                                style: TextStyle(
                                  fontFamily: FontFamily.sofiaProBold,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: notifier.textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${getData.read("Currency")} ${completePriceController.completePriceModel!.priceList.finalPrice}",
                                style: TextStyle(
                                  fontFamily: FontFamily.sofiaProBold,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: notifier.textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 15),
                              ExpansionTile(
                                onExpansionChanged: (bool expanded) {
                                  setState(() {
                                    customTileExpanded = expanded;
                                  });
                                },
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                childrenPadding: EdgeInsets.zero,
                                initiallyExpanded: true,
                                title: Text(
                                  "Total trip fare".tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.sofiaProBold,
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w500,
                                    color: notifier.textColor,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${getData.read("Currency")} ${completePriceController.completePriceModel!.priceList.finalPrice}",
                                      style: TextStyle(
                                        fontFamily: FontFamily.sofiaProBold,
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w500,
                                        color: notifier.textColor,
                                      ),
                                    ),
                                    customTileExpanded
                                        ? Icon(
                                            Icons.keyboard_arrow_up_outlined,
                                            size: 23,
                                            color: greyText,
                                          )
                                        : Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            size: 23,
                                            color: greyText,
                                          ),
                                  ],
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 17,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Ride Charges".tr,
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.sofiaProRegular,
                                            fontSize: 14,
                                            color: greyText,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${getData.read("Currency")} ${completePriceController.completePriceModel!.priceList.totPrice}",
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.sofiaProRegular,
                                            fontSize: 14,
                                            color: greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 17,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Discount".tr,
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.sofiaProRegular,
                                            fontSize: 14,
                                            color: greyText,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "-${getData.read("Currency")} ${completePriceController.completePriceModel!.priceList.couponAmount}",
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.sofiaProRegular,
                                            fontSize: 14,
                                            color: greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 17,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Additional time".tr,
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.sofiaProRegular,
                                            fontSize: 14,
                                            color: greyText,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${getData.read("Currency")} ${completePriceController.completePriceModel!.priceList.addiTimePrice}",
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.sofiaProRegular,
                                            fontSize: 14,
                                            color: greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 17,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Weather Price".tr,
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.sofiaProRegular,
                                            fontSize: 14,
                                            color: greyText,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${getData.read("Currency")} ${completePriceController.completePriceModel!.priceList.weatherPrice}",
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.sofiaProRegular,
                                            fontSize: 14,
                                            color: greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 17,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Platform Fees".tr,
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.sofiaProRegular,
                                            fontSize: 14,
                                            color: greyText,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${getData.read("Currency")} ${completePriceController.completePriceModel!.priceList.platformFee}",
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.sofiaProRegular,
                                            fontSize: 14,
                                            color: greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 17,
                                ),
                                dense: true,
                                minVerticalPadding: 0,
                                visualDensity: VisualDensity.compact,
                                title: Text(
                                  "AMOUNT TO BE PAID".tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.sofiaProBold,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: notifier.textColor,
                                  ),
                                ),
                                trailing: Text(
                                  "${getData.read("Currency")} ${completePriceController.completePriceModel!.priceList.finalPrice}",
                                  style: TextStyle(
                                    fontFamily: FontFamily.sofiaProBold,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: notifier.textColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: notifier.containerColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pay via".tr,
                                style: TextStyle(
                                  fontFamily: FontFamily.sofiaProBold,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: notifier.textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // margin: const EdgeInsets.all(10),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      border: Border.all(
                                        color: notifier.borderColor,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(65),
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            "assets/image/ezgif.com-crop.gif",
                                        placeholderCacheWidth: 50,
                                        placeholderCacheHeight: 50,
                                        image:
                                            "${Config.imageUrl}${completePriceController.completePriceModel!.paymentData.image}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    completePriceController
                                        .completePriceModel!.paymentData.name,
                                    style: TextStyle(
                                      fontFamily: FontFamily.sofiaProBold,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: notifier.textColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator(color: appColor));
        },
      ),
      bottomNavigationBar: buttonStatus == 0
          ? Container(
              color: notifier.containerColor,
              padding: const EdgeInsets.all(10),
              child: button(
                text: "Next".tr,
                color: appColor,
                onPress: () {
                  setState(() {
                    snackBar(
                      context: context,
                      text: "Waiting for the Payment".tr,
                    );
                  });
                },
              ),
            )
          : Container(
              color: notifier.containerColor,
              padding: const EdgeInsets.all(10),
              child: button(
                text: "Done".tr,
                color: appColor,
                onPress: () {
                  setState(() {
                    rateBottomSheet(newRequestId: rateRequestID);
                  });
                },
              ),
            ),
    );
  }

  Future rateBottomSheet({required String newRequestId}) {
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
                              "Paid ${getData.read("Currency")}${completePriceController.completePriceModel!.priceList.finalPrice}",
                              style: TextStyle(
                                fontFamily: FontFamily.sofiaProBold,
                                fontSize: 15,
                                // fontWeight: FontWeight.w500,
                                color: notifier.textColor,
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
                              completePriceController
                                  .completePriceModel!.priceList.cusName[0]
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
                          "How was your ride with ${completePriceController.completePriceModel!.priceList.cusName}",
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
                          "Great, what did you like the most? 😍",
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
                          itemCount: completePriceController
                              .completePriceModel!.reviewList.length,
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
                                    completePriceController.completePriceModel!
                                        .reviewList[index].id,
                                  )) {
                                    rateReviewController.reviewList.remove(
                                      completePriceController
                                          .completePriceModel!
                                          .reviewList[index]
                                          .id,
                                    );
                                    print(
                                      "-------remove--------- ${rateReviewController.reviewList}",
                                    );
                                  } else {
                                    rateReviewController.reviewList.add(
                                      completePriceController
                                          .completePriceModel!
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
                                    completePriceController.completePriceModel!
                                        .reviewList[index].id,
                                  )
                                          ? appColor
                                          : notifier.containerColor,
                                  borderRadius: BorderRadius.circular(35),
                                  border: Border.all(
                                    color: rateReviewController.reviewList
                                            .contains(
                                      completePriceController
                                          .completePriceModel!
                                          .reviewList[index]
                                          .id,
                                    )
                                        ? appColor
                                        : notifier.borderColor,
                                  ),
                                ),
                                child: Text(
                                  completePriceController.completePriceModel!
                                      .reviewList[index].title,
                                  style: TextStyle(
                                    fontFamily: FontFamily.sofiaProBold,
                                    fontSize: 13,
                                    color: rateReviewController.reviewList
                                            .contains(
                                      completePriceController
                                          .completePriceModel!
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
                              requestId: newRequestId,
                              cID: widget.cID.toString(),
                            );
                            socket.close();
                            setState(() {});
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
                              socket.close();
                              currentIndexBottom = 0;
                              Get.offAll(const BottomBarScreen());
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
