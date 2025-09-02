import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qareeb/screen/home/past_request_screen.dart';
import '../../config/data_store.dart';
import '../../controller/my_earning_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/dark_light_mode.dart';

List<String> dropList = <String>[
  'All'.tr,
  'Yesterday'.tr,
  'Last week'.tr,
  'Last month'.tr,
  'Last year'.tr,
];

class MyEarning extends StatefulWidget {
  const MyEarning({super.key});

  @override
  State<MyEarning> createState() => _MyEarningState();
}

class _MyEarningState extends State<MyEarning> {
  MyEarningController myEarningController = Get.put(MyEarningController());

  @override
  void initState() {
    getDarkMode();
    log("---------------- ${getData.read("UserLogin")}");
    myEarningController.myEarningApi(context: context, selection: "");

    super.initState();
  }

  String dropdownValue = dropList.first;

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
          "My Earning".tr,
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 17,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
      ),
      body: GetBuilder<MyEarningController>(
        builder: (context) {
          return RefreshIndicator(
            color: appColor,
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 2), () {
                myEarningController.myEarningApi(
                  context: context,
                  selection: "",
                );
              });
            },
            child: myEarningController.isLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: notifier.containerColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: notifier.borderColor,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Today's Earning".tr,
                                          style: TextStyle(
                                            color: notifier.textColor,
                                            fontSize: 15,
                                            fontFamily:
                                                FontFamily.sofiaProRegular,
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${getData.read("Currency")}${myEarningController.myEarningModel!.earnings.todayPrice}",
                                        style: TextStyle(
                                          color: Colors.green.shade900,
                                          fontSize: 18,
                                          fontFamily: FontFamily.sofiaProBold,
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                      // const SizedBox(height: 3),
                                    ],
                                  ),
                                ),
                                // SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: notifier.borderColor,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "Today's Tips".tr,
                                          style: TextStyle(
                                            color: notifier.textColor,
                                            fontSize: 15,
                                            fontFamily:
                                                FontFamily.sofiaProRegular,
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${getData.read("Currency")}${myEarningController.myEarningModel!.earnings.todayTrip}",
                                        style: TextStyle(
                                          color: Colors.green.shade900,
                                          fontSize: 18,
                                          fontFamily: FontFamily.sofiaProBold,
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                      // const SizedBox(height: 3),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: notifier.borderColor,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "Today's Login Hrs".tr,
                                          style: TextStyle(
                                            color: notifier.textColor,
                                            fontSize: 15,
                                            fontFamily:
                                                FontFamily.sofiaProRegular,
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${myEarningController.myEarningModel!.earnings.todayMinute} Hrs",
                                        style: TextStyle(
                                          color: Colors.green.shade900,
                                          fontSize: 18,
                                          fontFamily: FontFamily.sofiaProBold,
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(15),
                            color: notifier.containerColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Earning & Rides".tr,
                                      style: TextStyle(
                                        color: notifier.textColor,
                                        fontSize: 19,
                                        fontFamily: FontFamily.sofiaProBold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: notifier.containerColor,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: notifier.borderColor,
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        padding: EdgeInsets.zero,
                                        isDense: true,
                                        dropdownColor: notifier.background,
                                        value: dropdownValue,
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: notifier.textColor,
                                        ),
                                        iconSize: 24,
                                        underline: const SizedBox(),
                                        style: TextStyle(
                                          color: notifier.textColor,
                                          fontSize: 16,
                                          fontFamily:
                                              FontFamily.sofiaProRegular,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                            print(
                                              "*********'''''''' c$dropdownValue",
                                            );
                                            if (dropdownValue == "All") {
                                              myEarningController.myEarningApi(
                                                context: context,
                                                selection: "",
                                              );
                                            } else if (dropdownValue ==
                                                "Yesterday") {
                                              myEarningController.myEarningApi(
                                                context: context,
                                                selection: "yesterday",
                                              );
                                            } else if (dropdownValue ==
                                                "Last week") {
                                              myEarningController.myEarningApi(
                                                context: context,
                                                selection: "lastweek",
                                              );
                                            } else if (dropdownValue ==
                                                "Last month") {
                                              myEarningController.myEarningApi(
                                                context: context,
                                                selection: "lastmonth",
                                              );
                                            } else if (dropdownValue ==
                                                "Last year") {
                                              myEarningController.myEarningApi(
                                                context: context,
                                                selection: "lastyear",
                                              );
                                            }
                                          });
                                        },
                                        items: dropList
                                            .map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: notifier.textColor,
                                                fontSize: 16,
                                                fontFamily:
                                                    FontFamily.sofiaProRegular,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Center(
                                  child: Text(
                                    "${getData.read("Currency")}${myEarningController.myEarningModel!.earnings.totPrice.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: notifier.textColor,
                                      fontSize: 25,
                                      fontFamily: FontFamily.sofiaProBold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: notifier.borderColor,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Total Trips".tr,
                                                style: TextStyle(
                                                  color: notifier.textColor,
                                                  fontSize: 15,
                                                  fontFamily: FontFamily
                                                      .sofiaProRegular,
                                                ),
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "${myEarningController.myEarningModel!.earnings.totTrip}",
                                                style: TextStyle(
                                                  color: Colors.green.shade900,
                                                  fontSize: 18,
                                                  fontFamily:
                                                      FontFamily.sofiaProBold,
                                                ),
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                              // const SizedBox(height: 3),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: notifier.borderColor,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Total Driving Hrs".tr,
                                                style: TextStyle(
                                                  color: notifier.textColor,
                                                  fontSize: 15,
                                                  fontFamily: FontFamily
                                                      .sofiaProRegular,
                                                ),
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "${myEarningController.myEarningModel!.earnings.totMinute} Hrs",
                                                style: TextStyle(
                                                  color: Colors.green.shade900,
                                                  fontSize: 18,
                                                  fontFamily:
                                                      FontFamily.sofiaProBold,
                                                ),
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                              // const SizedBox(height: 3),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          myEarningController
                                  .myEarningModel!.rideData.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 15),
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      color: notifier.containerColor,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Recommended Bookings".tr,
                                                style: TextStyle(
                                                  color: notifier.textColor,
                                                  fontSize: 18,
                                                  fontFamily:
                                                      FontFamily.sofiaProBold,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(const HistoryScreen());
                                                },
                                                child: Text(
                                                  "View All".tr,
                                                  style: TextStyle(
                                                    color: appColor,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        FontFamily.sofiaProBold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          SizedBox(
                                            height: 242,
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: myEarningController
                                                  .myEarningModel!
                                                  .rideData
                                                  .length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(width: 20),
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  width: Get.width - 30,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        notifier.containerColor,
                                                    border: Border(
                                                      left: BorderSide(
                                                        color: notifier
                                                            .borderColor,
                                                      ),
                                                      right: BorderSide(
                                                        color: notifier
                                                            .borderColor,
                                                      ),
                                                      top: BorderSide(
                                                        color: notifier
                                                            .borderColor,
                                                      ),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      12,
                                                    ),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(
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
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    height: 50,
                                                                    width: 50,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: appColor
                                                                          .withOpacity(
                                                                        0.12,
                                                                      ),
                                                                    ),
                                                                    child: Icon(
                                                                      Icons
                                                                          .directions_bike_rounded,
                                                                      color:
                                                                          appColor,
                                                                      size: 22,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Flexible(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "Trip #${myEarningController.myEarningModel!.rideData[index].id}",
                                                                              style: TextStyle(
                                                                                color: notifier.textColor,
                                                                                fontSize: 14,
                                                                                fontFamily: FontFamily.sofiaProBold,
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              alignment: Alignment.center,
                                                                              // height: 30,
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal: 8,
                                                                                vertical: 5,
                                                                              ),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.green.shade900,
                                                                                borderRadius: BorderRadius.circular(
                                                                                  35,
                                                                                ),
                                                                              ),
                                                                              child: Text(
                                                                                myEarningController.myEarningModel!.rideData[index].startTime,
                                                                                style: TextStyle(
                                                                                  color: notifier.containerColor,
                                                                                  fontSize: 10,
                                                                                  fontFamily: FontFamily.sofiaProRegular,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "Estimate Usage: ".tr,
                                                                              style: TextStyle(
                                                                                color: greyText2,
                                                                                fontSize: 12,
                                                                                fontFamily: FontFamily.sofiaProRegular,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "${myEarningController.myEarningModel!.rideData[index].totMinute} Hrs ",
                                                                              style: TextStyle(
                                                                                color: notifier.textColor,
                                                                                fontSize: 13,
                                                                                fontFamily: FontFamily.sofiaProRegular,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 3,
                                                                            ),
                                                                            Container(
                                                                              height: 12,
                                                                              width: 1.5,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  25,
                                                                                ),
                                                                                color: notifier.borderColor,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 4,
                                                                            ),
                                                                            Text(
                                                                              "Total Dist: ".tr,
                                                                              style: TextStyle(
                                                                                color: greyText2,
                                                                                fontSize: 12,
                                                                                fontFamily: FontFamily.sofiaProRegular,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "${double.parse(myEarningController.myEarningModel!.rideData[index].totKm).toStringAsFixed(0)} Km",
                                                                              style: TextStyle(
                                                                                color: notifier.textColor,
                                                                                fontSize: 13,
                                                                                fontFamily: FontFamily.sofiaProRegular,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
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
                                                                height: 20,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 10,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.green.shade50,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                10,
                                                                            width:
                                                                                10,
                                                                            margin:
                                                                                const EdgeInsets.all(
                                                                              6,
                                                                            ),
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              color: Colors.green,
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            "${myEarningController.myEarningModel!.rideData[index].picAddress.title}, ${myEarningController.myEarningModel!.rideData[index].picAddress.subtitle}",
                                                                            style:
                                                                                TextStyle(
                                                                              color: greyText2,
                                                                              fontSize: 13.5,
                                                                              fontFamily: FontFamily.sofiaProRegular,
                                                                            ),
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              1,
                                                                          decoration:
                                                                              BoxDecoration(
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
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.red.shade50,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                const EdgeInsets.all(
                                                                              6,
                                                                            ),
                                                                            height:
                                                                                10,
                                                                            width:
                                                                                10,
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              color: Colors.red,
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            "${myEarningController.myEarningModel!.rideData[index].dropAddress.title}, ${myEarningController.myEarningModel!.rideData[index].dropAddress.subtitle}",
                                                                            style:
                                                                                TextStyle(
                                                                              color: greyText2,
                                                                              fontSize: 13.5,
                                                                              fontFamily: FontFamily.sofiaProRegular,
                                                                            ),
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 50,
                                                          width: Get.width,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: appColor
                                                                .withOpacity(
                                                              0.12,
                                                            ),
                                                            border: Border(
                                                              top: BorderSide(
                                                                color: notifier
                                                                    .borderColor,
                                                              ),
                                                            ),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                12,
                                                              ),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
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
                                                                "${getData.read("Currency")}${myEarningController.myEarningModel!.rideData[index].finalPrice}",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      appColor,
                                                                  fontSize: 17,
                                                                  fontFamily:
                                                                      FontFamily
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator(color: appColor)),
          );
        },
      ),
    );
  }
}
