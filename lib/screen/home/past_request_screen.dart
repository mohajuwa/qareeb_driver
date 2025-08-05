import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qareeb/config/data_store.dart';
import 'package:qareeb/screen/home/past_detail_screen.dart';

import '../../controller/ride_history_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/dark_light_mode.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  RideHistoryController rideHistoryController = Get.put(
    RideHistoryController(),
  );

  @override
  void initState() {
    getDarkMode();
    rideHistoryController.rideHistoryApi(context: context);
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
        // centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: notifier.textColor),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "History".tr,
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 19,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
      ),
      body: GetBuilder<RideHistoryController>(
        builder: (context) {
          return rideHistoryController.isLoading
              ? rideHistoryController.rideHistoryModel!.rideData.isNotEmpty
                  ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            // height: Get.height,
                            margin: const EdgeInsets.only(top: 15),
                            padding: const EdgeInsets.all(10),
                            color: notifier.containerColor,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: rideHistoryController
                                  .rideHistoryModel!.rideData.length,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 30),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
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
                                                  BorderRadius.circular(25),
                                              color: notifier.borderColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          rideHistoryController
                                              .rideHistoryModel!
                                              .rideData[index]
                                              .date
                                              .toUpperCase(),
                                          style: TextStyle(
                                            color: greyText2,
                                            fontSize: 12,
                                            letterSpacing: 0.5,
                                            fontFamily: FontFamily.sofiaProBold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                            height: 1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: notifier.borderColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 25),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: rideHistoryController
                                          .rideHistoryModel!
                                          .rideData[index]
                                          .detail
                                          .length,
                                      separatorBuilder: (context, index1) =>
                                          const SizedBox(height: 20),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index1) {
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              PastDetailScreen(
                                                requestId:
                                                    "${rideHistoryController.rideHistoryModel!.rideData[index].detail[index1].id}",
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              color: notifier.containerColor,
                                              border: Border(
                                                left: BorderSide(
                                                  color: notifier.borderColor,
                                                ),
                                                right: BorderSide(
                                                  color: notifier.borderColor,
                                                ),
                                                top: BorderSide(
                                                  color: notifier.borderColor,
                                                ),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    10,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            rideHistoryController
                                                                .rideHistoryModel!
                                                                .rideData[index]
                                                                .detail[index1]
                                                                .cusName,
                                                            style: TextStyle(
                                                              color: notifier
                                                                  .textColor,
                                                              fontSize: 13.5,
                                                              fontFamily: FontFamily
                                                                  .sofiaProBold,
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            CupertinoIcons
                                                                .calendar,
                                                            size: 20,
                                                            color: notifier
                                                                .textColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            rideHistoryController
                                                                .rideHistoryModel!
                                                                .rideData[index]
                                                                .detail[index1]
                                                                .startTime,
                                                            style: TextStyle(
                                                              color: greyText2,
                                                              fontSize: 13.5,
                                                              fontFamily: FontFamily
                                                                  .sofiaProBold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        "ID #${rideHistoryController.rideHistoryModel!.rideData[index].detail[index1].id}",
                                                        style: TextStyle(
                                                          color: greyText2,
                                                          fontSize: 13.5,
                                                          fontFamily: FontFamily
                                                              .sofiaProRegular,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 25,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 10,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .green
                                                                        .shade50,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    height: 10,
                                                                    width: 10,
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .all(
                                                                      6,
                                                                    ),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Colors
                                                                          .green,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                    "${rideHistoryController.rideHistoryModel!.rideData[index].detail[index1].picAddress.title}, ${rideHistoryController.rideHistoryModel!.rideData[index].detail[index1].picAddress.subtitle}",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          greyText2,
                                                                      fontSize:
                                                                          13.5,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .sofiaProRegular,
                                                                    ),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              height: 1,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  25,
                                                                ),
                                                                color: notifier
                                                                    .borderColor,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .red
                                                                        .shade50,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .all(
                                                                      6,
                                                                    ),
                                                                    height: 10,
                                                                    width: 10,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                    "${rideHistoryController.rideHistoryModel!.rideData[index].detail[index1].dropAddress.title}, ${rideHistoryController.rideHistoryModel!.rideData[index].detail[index1].dropAddress.subtitle}",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          greyText2,
                                                                      fontSize:
                                                                          13.5,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .sofiaProRegular,
                                                                    ),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 25,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .directions_bike_outlined,
                                                            size: 20,
                                                            color: notifier
                                                                .textColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            rideHistoryController
                                                                .rideHistoryModel!
                                                                .rideData[index]
                                                                .detail[index1]
                                                                .vehicleName,
                                                            style: TextStyle(
                                                              color: greyText2,
                                                              fontSize: 13.5,
                                                              fontFamily: FontFamily
                                                                  .sofiaProBold,
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons
                                                                .route_outlined,
                                                            size: 20,
                                                            color: notifier
                                                                .textColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            "${rideHistoryController.rideHistoryModel!.rideData[index].detail[index1].totKm} km",
                                                            style: TextStyle(
                                                              color: greyText2,
                                                              fontSize: 13.5,
                                                              fontFamily: FontFamily
                                                                  .sofiaProBold,
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.timer,
                                                            size: 20,
                                                            color: notifier
                                                                .textColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            "${rideHistoryController.rideHistoryModel!.rideData[index].detail[index1].totMinute} Hrs",
                                                            style: TextStyle(
                                                              color: greyText2,
                                                              fontSize: 13.5,
                                                              fontFamily: FontFamily
                                                                  .sofiaProBold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // const SizedBox(height: 75),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 17),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 50,
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                    color: appColor
                                                        .withOpacity(0.12),
                                                    border: Border(
                                                      top: BorderSide(
                                                        color: notifier
                                                            .borderColor,
                                                      ),
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(
                                                        12,
                                                      ),
                                                      bottomRight:
                                                          Radius.circular(
                                                        12,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.wallet,
                                                        size: 22,
                                                        color: appColor,
                                                      ),
                                                      const SizedBox(
                                                        width: 6,
                                                      ),
                                                      Text(
                                                        "${getData.read("Currency")}${rideHistoryController.rideHistoryModel!.rideData[index].detail[index1].finalPrice}",
                                                        style: TextStyle(
                                                          color: appColor,
                                                          fontSize: 17,
                                                          fontFamily: FontFamily
                                                              .sofiaProBold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            "No History Found!".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.sofiaProBold,
                              color: notifier.textColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Currently you don’t have history.".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.sofiaProRegular,
                              fontSize: 15,
                              color: greyText,
                            ),
                          ),
                        ],
                      ),
                    )
              : Center(child: CircularProgressIndicator(color: appColor));
        },
      ),
    );
  }
}
