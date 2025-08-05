// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qareeb/config/config.dart';
import '../../config/data_store.dart';
import '../../controller/driver_info_controller.dart';
import '../../controller/info_detail_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/common.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  get picker => ImagePicker();

  DriverInfoController driverInfoController = Get.put(DriverInfoController());
  InfoDetailController infoDetailController = Get.put(InfoDetailController());

  @override
  void initState() {
    fun();
    // log("------userData---------- ${getData.read("UserLogin")}");
    // log("------id---------- ${getData.read("UserLogin")["id"]}");
    super.initState();
  }

  fun() {
    infoDetailController.infoDetailApi(context: context).then((value) {
      // personalInfoController.zoneTagList = infoDetailController.infoDetailModel!.zoneData.map((zone) => zone.name.toString()).toList();
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
          "Vehicles Information".tr,
          style: TextStyle(
            color: blackColor,
            fontSize: 16,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: GetBuilder<DriverInfoController>(
          builder: (driverInfoController) {
            return driverInfoController.isLoading
                ? SizedBox(
                    height: 40,
                    child: Center(
                      child: CircularProgressIndicator(color: appColor),
                    ),
                  )
                : button(
                    text: "SUBMIT AND NEXT".tr,
                    color: appColor,
                    onPress: () {
                      print(
                        "++++++++++++++++++++++++++++ ${driverInfoController.isLoading}",
                      );
                      if (driverInfoController
                              .vehicleController.text.isNotEmpty &&
                          driverInfoController.galleryFile != null &&
                          driverInfoController
                              .vehicleNumberController.text.isNotEmpty &&
                          driverInfoController
                              .colorController.text.isNotEmpty &&
                          driverInfoController
                              .capacityController.text.isNotEmpty &&
                          driverInfoController.preferenceList.isNotEmpty) {
                        setState(() {
                          driverInfoController.isLoading = true;
                        });
                        driverInfoController.driverInfoApi(context: context);
                        setState(() {});
                      } else {
                        snackBar(
                          context: context,
                          text: "Please Enter All Details".tr,
                        );
                      }
                    },
                  );
          },
        ),
      ),
      body: GetBuilder<InfoDetailController>(
        builder: (infoDetailController) {
          return infoDetailController.isLoading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    stepWiseLiner(value: 0.50),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 13,
                              ),
                              child: TypeAheadField(
                                controller:
                                    driverInfoController.vehicleController,
                                builder: (context, controller, focusNode) {
                                  return TextFormField(
                                    controller:
                                        driverInfoController.vehicleController,
                                    focusNode: focusNode,
                                    style: TextStyle(
                                      color: blackColor,
                                      fontFamily: FontFamily.sofiaProRegular,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Select Vehicle'.tr,
                                      labelStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontFamily: FontFamily.sofiaRegular,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                        top: 20,
                                        left: 12,
                                        right: 12,
                                        bottom: 20,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: appColor),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                    ),
                                  );
                                },
                                emptyBuilder: (context) => Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "No Vehicle Found...!!!".tr,
                                    style: TextStyle(
                                      color: blackColor,
                                      fontFamily: FontFamily.sofiaProRegular,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                onSelected: (item) {
                                  print(item.name);
                                  setState(() {
                                    driverInfoController.vehicleId =
                                        item.id.toString();
                                  });
                                  driverInfoController.vehicleController.text =
                                      item.name;
                                },
                                suggestionsCallback: (pattern) async {
                                  return infoDetailController
                                      .infoDetailModel!.vehicleList
                                      .where(
                                        (element) => element.name
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()),
                                      )
                                      .toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    leading: Container(
                                      // margin: const EdgeInsets.all(10),
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        // border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              "assets/image/ezgif.com-crop.gif",
                                          placeholderCacheWidth: 25,
                                          placeholderCacheHeight: 25,
                                          image:
                                              "${Config.imageUrl}${suggestion.image}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    minLeadingWidth: 0,
                                    title: Text(
                                      suggestion.name,
                                      style: TextStyle(
                                        color: blackColor,
                                        fontFamily: FontFamily.sofiaProRegular,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 18),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                              ),
                              child: Text(
                                "Vehicle image".tr,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: FontFamily.sofiaRegular,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 100,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 13,
                              ),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                color: driverInfoController.galleryFile == null
                                    ? greyText
                                    : appColor,
                                radius: const Radius.circular(15),
                                // borderPadding: EdgeInsets.symmetric(horizontal: 20),
                                child: InkWell(
                                  onTap: () {
                                    getImage(ImageSource.gallery, context);
                                    setState(() {});
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      // height: 80,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 13,
                                        vertical: 14,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      width: Get.size.width,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: driverInfoController.galleryFile ==
                                              null
                                          ? Image.asset(
                                              "assets/image/uplodeimage.png",
                                              height: 40,
                                              width: 42,
                                            )
                                          : Container(
                                              height: 120,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                image: DecorationImage(
                                                  image: FileImage(
                                                    driverInfoController
                                                        .galleryFile!,
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
                            const SizedBox(height: 25),
                            textfield(
                              controller:
                                  driverInfoController.vehicleNumberController,
                              label: "Vehicle Registration Number".tr,
                            ),
                            const SizedBox(height: 18),
                            textfield(
                              controller: driverInfoController.colorController,
                              label: "Vehicle Color".tr,
                            ),
                            const SizedBox(height: 18),
                            textfield(
                              textInputType: TextInputType.phone,
                              controller:
                                  driverInfoController.capacityController,
                              label: "Passenger Capacity".tr,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                              ),
                              child: Text(
                                "Vehicle Preference".tr,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: FontFamily.sofiaRegular,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: infoDetailController
                                  .infoDetailModel!.preferenceList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                mainAxisExtent: 48,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (driverInfoController.preferenceList
                                          .contains(
                                        infoDetailController.infoDetailModel!
                                            .preferenceList[index].id,
                                      )) {
                                        driverInfoController.preferenceList
                                            .remove(
                                          infoDetailController.infoDetailModel!
                                              .preferenceList[index].id,
                                        );
                                        print(
                                          "-------remove--------- ${driverInfoController.preferenceList}",
                                        );
                                      } else {
                                        driverInfoController.preferenceList.add(
                                          infoDetailController.infoDetailModel!
                                              .preferenceList[index].id,
                                        );
                                        print(
                                          "+++++++Add+++++++ ${driverInfoController.preferenceList}",
                                        );
                                      }
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: driverInfoController.preferenceList
                                              .contains(
                                        infoDetailController.infoDetailModel!
                                            .preferenceList[index].id,
                                      )
                                          ? appColor
                                          : whiteColor,
                                      borderRadius: BorderRadius.circular(35),
                                      border: Border.all(
                                        color: driverInfoController
                                                .preferenceList
                                                .contains(
                                          infoDetailController.infoDetailModel!
                                              .preferenceList[index].id,
                                        )
                                            ? appColor
                                            : Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          // margin: const EdgeInsets.all(10),
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: whiteColor,
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  "assets/image/ezgif.com-crop.gif",
                                              placeholderCacheWidth: 30,
                                              placeholderCacheHeight: 30,
                                              image:
                                                  "${Config.imageUrl}${infoDetailController.infoDetailModel!.preferenceList[index].image}",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            infoDetailController
                                                .infoDetailModel!
                                                .preferenceList[index]
                                                .name,
                                            style: TextStyle(
                                              fontFamily:
                                                  FontFamily.sofiaRegular,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: driverInfoController
                                                      .preferenceList
                                                      .contains(
                                                infoDetailController
                                                    .infoDetailModel!
                                                    .preferenceList[index]
                                                    .id,
                                              )
                                                  ? whiteColor
                                                  : blackColor,
                                              letterSpacing: 0.3,
                                            ),
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
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

  Future getImage(ImageSource img, context) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    if (xfilePick != null) {
      driverInfoController.galleryFile = File(pickedFile!.path);
      driverInfoController.xFileImage = xfilePick;
      setState(() {});
    } else {
      snackBar(context: context, text: "Nothing is Selected".tr);
    }
    setState(() {});
  }
}
