// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:qareeb/controller/personal_info_controller.dart';
import 'package:qareeb/utils/colors.dart';
import 'package:get/get.dart';
import 'package:qareeb/widget/common.dart';
import '../../controller/info_detail_controller.dart';
import '../../utils/font_family.dart';

class PersonalInfo extends StatefulWidget {
  final String primaryMobile;
  final String primaryCode;

  const PersonalInfo({
    super.key,
    required this.primaryMobile,
    required this.primaryCode,
  });

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  // LoginController loginController = Get.put(LoginController());

  PersonalInfoController personalInfoController = Get.put(
    PersonalInfoController(),
  );
  InfoDetailController infoDetailController = Get.put(InfoDetailController());

  get picker => ImagePicker();

  @override
  void initState() {
    fun();
    super.initState();
  }

  fun() {
    infoDetailController.infoDetailApi(context: context).then((value) {
      personalInfoController.zoneTagList = infoDetailController
          .infoDetailModel!.zoneData
          .map((zone) => zone.name.toString())
          .toList();
      setState(() {});
    });
    setState(() {});
  }

  // bool isLoading = true;

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
          "Personal Information".tr,
          style: TextStyle(
            color: blackColor,
            fontSize: 16,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
      ),
      body: GetBuilder<InfoDetailController>(
        builder: (infoDetailController) {
          return infoDetailController.isLoading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    stepWiseLiner(value: 0.25),
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: whiteColor,
                              ),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.disabled,
                                onTap: () {
                                  snackBar(
                                    context: context,
                                    text:
                                        "Oops! Sorry You Can't Change This Number",
                                  );
                                },
                                readOnly: true,
                                style: TextStyle(
                                  color: blackColor,
                                  fontFamily: FontFamily.sofiaProRegular,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  // prefixText: widget.primaryCode,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 16,
                                      left: 11,
                                      right: 6,
                                    ),
                                    child: Text(
                                      widget.primaryCode,
                                      style: TextStyle(
                                        color: blackColor,
                                        fontFamily: FontFamily.sofiaProRegular,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  hintText: widget.primaryMobile,
                                  hintStyle: TextStyle(
                                    color: blackColor,
                                    fontFamily: FontFamily.sofiaProRegular,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 13,
                              ),
                              child: IntlPhoneField(
                                controller:
                                    personalInfoController.secondaryPhone,
                                keyboardType: TextInputType.phone,
                                cursorColor: appColor,
                                style: TextStyle(
                                  fontFamily: FontFamily.sofiaProRegular,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: blackColor,
                                  letterSpacing: 0.3,
                                ),
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: FontFamily.sofiaRegular,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  counterText: "",
                                  labelText: "Secondary mobile number".tr,
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
                                flagsButtonPadding: EdgeInsets.zero,
                                showCountryFlag: false,
                                showDropdownIcon: false,
                                initialCountryCode: 'IN',
                                autovalidateMode: AutovalidateMode.disabled,
                                dropdownTextStyle: TextStyle(
                                  fontFamily: FontFamily.sofiaProRegular,
                                  fontSize: 14,
                                  color: blackColor,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                                onChanged: (number) {
                                  setState(() {
                                    personalInfoController.secondaryccode =
                                        number.countryCode;

                                    // passwordController.text.isEmpty ? passwordvalidate = true : false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 18),
                            textfield(
                              controller: personalInfoController.firstName,
                              label: "First name".tr,
                            ),
                            const SizedBox(height: 18),
                            textfield(
                              controller: personalInfoController.lastName,
                              label: "Last name".tr,
                            ),
                            const SizedBox(height: 18),
                            textfield(
                              controller: personalInfoController.email,
                              label: "E-Mail".tr,
                            ),
                            const SizedBox(height: 18),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 13,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: whiteColor,
                              ),
                              child: TextFormField(
                                controller: personalInfoController.password,
                                obscureText: personalInfoController.obscureText,
                                cursorColor: appColor,
                                style: TextStyle(
                                  color: blackColor,
                                  fontFamily: FontFamily.sofiaProRegular,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        personalInfoController.obscureText =
                                            !personalInfoController.obscureText;
                                      });
                                    },
                                    child: personalInfoController.obscureText ==
                                            false
                                        ? Icon(
                                            Icons.remove_red_eye,
                                            color: greyText,
                                            size: 19,
                                          )
                                        : Icon(
                                            Icons.visibility_off_rounded,
                                            color: greyText,
                                            size: 19,
                                          ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 12,
                                  ),
                                  labelText: "Enter Password".tr,
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: FontFamily.sofiaRegular,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: appColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            textfield(
                              controller: personalInfoController.nationality,
                              label: "Nationality".tr,
                            ),
                            const SizedBox(height: 18),
                            textfield(
                              readOnly: true,
                              controller: personalInfoController.dateController,
                              label: "Date of Birth".tr,
                              onTap: () {
                                setState(() {
                                  datePicker();
                                });
                              },
                              suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    datePicker();
                                  });
                                },
                                child: const Icon(
                                  CupertinoIcons.calendar,
                                  size: 22,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                              ),
                              child: Text(
                                "Vehicle Preference".tr,
                                style: TextStyle(
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
                                  .infoDetailModel!.zoneData.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                mainAxisExtent: 45,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (personalInfoController.zoneList
                                          .contains(
                                        infoDetailController.infoDetailModel!
                                            .zoneData[index].id,
                                      )) {
                                        personalInfoController.zoneList.remove(
                                          infoDetailController.infoDetailModel!
                                              .zoneData[index].id,
                                        );
                                        print(
                                          "-------remove--------- ${personalInfoController.zoneList}",
                                        );
                                      } else {
                                        personalInfoController.zoneList.add(
                                          infoDetailController.infoDetailModel!
                                              .zoneData[index].id,
                                        );
                                        print(
                                          "+++++++Add+++++++ ${personalInfoController.zoneList}",
                                        );
                                      }
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: personalInfoController.zoneList
                                              .contains(
                                        infoDetailController.infoDetailModel!
                                            .zoneData[index].id,
                                      )
                                          ? appColor
                                          : whiteColor,
                                      borderRadius: BorderRadius.circular(35),
                                      border: Border.all(
                                        color: personalInfoController.zoneList
                                                .contains(
                                          infoDetailController.infoDetailModel!
                                              .zoneData[index].id,
                                        )
                                            ? appColor
                                            : Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Text(
                                      infoDetailController.infoDetailModel!
                                          .zoneData[index].name,
                                      style: TextStyle(
                                        fontFamily: FontFamily.sofiaRegular,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: personalInfoController.zoneList
                                                .contains(
                                          infoDetailController.infoDetailModel!
                                              .zoneData[index].id,
                                        )
                                            ? whiteColor
                                            : blackColor,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            textfield(
                              controller: personalInfoController.address,
                              maxLines: 5,
                              labelText: "Complete address".tr,
                            ),
                            const SizedBox(height: 18),
                            languageTag(),
                            const SizedBox(height: 18),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                              ),
                              child: Text(
                                "Profile Picture".tr,
                                style: TextStyle(
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
                                color:
                                    personalInfoController.galleryFile == null
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
                                      child: personalInfoController
                                                  .galleryFile ==
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
                                                    personalInfoController
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
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator(color: appColor));
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: GetBuilder<PersonalInfoController>(
          builder: (personalInfoController) {
            return personalInfoController.isLoading
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
                      print("${personalInfoController.galleryFile}");
                      print(widget.primaryMobile);
                      print(personalInfoController.secondaryPhone.text);
                      print(personalInfoController.firstName.text);
                      print(personalInfoController.lastName.text);
                      print(personalInfoController.email.text);
                      print(personalInfoController.password.text);
                      print(personalInfoController.nationality.text);
                      print(personalInfoController.dateController.text);
                      print(personalInfoController.address.text);
                      print("${personalInfoController.zoneList}");
                      print(
                        "${personalInfoController.languageTagController.getTags}",
                      );
                      if (personalInfoController.galleryFile != null &&
                          widget.primaryMobile.isNotEmpty &&
                          personalInfoController.firstName.text.isNotEmpty &&
                          personalInfoController.lastName.text.isNotEmpty &&
                          personalInfoController.email.text.isNotEmpty &&
                          personalInfoController.password.text.isNotEmpty &&
                          personalInfoController.nationality.text.isNotEmpty &&
                          personalInfoController
                              .dateController.text.isNotEmpty &&
                          personalInfoController.address.text.isNotEmpty &&
                          personalInfoController.zoneList.isNotEmpty &&
                          personalInfoController
                              .languageTagController.getTags!.isNotEmpty) {
                        setState(() {
                          personalInfoController.isLoading = true;
                        });
                        personalInfoController.personalInfoApi(
                          context: context,
                          primaryCode: widget.primaryCode.toString(),
                          primaryPhone: widget.primaryMobile.toString(),
                        );
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
    );
  }

  Future datePicker() {
    return showCupertinoModalPopup(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          width: Get.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: CupertinoDatePicker(
            backgroundColor: Colors.white,
            mode: CupertinoDatePickerMode.date,
            initialDateTime: personalInfoController.selectedDate,
            minimumYear: 1900,
            maximumYear: 2050,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                personalInfoController.selectedDate = newDateTime;
                personalInfoController.dateController.text =
                    "${personalInfoController.selectedDate.year}-${personalInfoController.selectedDate.month}-${personalInfoController.selectedDate.day}";
              });
            },
          ),
        );
      },
    );
  }

  Widget languageTag() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Add Language".tr,
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: FontFamily.sofiaRegular,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 5),
              Transform.translate(
                offset: const Offset(0, -3),
                child: Tooltip(
                  height: 50,
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: const Duration(seconds: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  textStyle: TextStyle(
                    fontFamily: FontFamily.gilroyMedium,
                    fontSize: 14,
                    letterSpacing: 0.5,
                    color: whiteColor,
                  ),
                  decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  message:
                      'You can add multiple Tags, but each tags must be followed by pressing Enter. '
                          .tr,
                  child: Transform.translate(
                    offset: const Offset(0, 3),
                    child: Icon(
                      CupertinoIcons.info_circle_fill,
                      color: appColor,
                      size: 21,
                    ),
                  ), //Text
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFieldTags(
            // textfieldTagsController: addlistofeventController.tegs,
            textfieldTagsController:
                personalInfoController.languageTagController,
            initialTags: personalInfoController.languageTagList,
            textSeparators: const [' ', ','],
            letterCase: LetterCase.normal,
            // validator: (String tag){
            //   if (tag == 'php'){
            //     return 'Php not allowed';
            //   }
            //   return null;
            // },
            inputFieldBuilder: (context, textFieldTagValues) {
              return TextField(
                controller: textFieldTagValues.textEditingController,
                focusNode: textFieldTagValues.focusNode,
                style: TextStyle(
                  color: blackColor,
                  fontFamily: FontFamily.sofiaProRegular,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColor),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: FontFamily.sofiaRegular,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: FontFamily.sofiaRegular,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: textFieldTagValues.textEditingController == null
                      ? ''
                      : "".tr,
                  errorText: textFieldTagValues.error,
                  // prefixIconConstraints: BoxConstraints(maxWidth:textFieldTagValues._distanceToField * 0.8),
                  prefixIcon: textFieldTagValues.tags.isNotEmpty
                      ? SingleChildScrollView(
                          controller: textFieldTagValues.tagScrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: textFieldTagValues.tags.map((String tag) {
                              return InkWell(
                                onTap: () {
                                  textFieldTagValues.onTagRemoved(tag);
                                },
                                child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: appColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    // gradient: appColor,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 5.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        child: Text(
                                          tag,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          //print("$tag selected");
                                        },
                                      ),
                                      const SizedBox(width: 4.0),
                                      InkWell(
                                        child: const Icon(
                                          Icons.cancel,
                                          size: 14.0,
                                          color: Color.fromARGB(
                                            255,
                                            233,
                                            233,
                                            233,
                                          ),
                                        ),
                                        onTap: () {
                                          textFieldTagValues.onTagRemoved(tag);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      : null,
                ),
                onChanged: textFieldTagValues.onTagChanged,
                onSubmitted: textFieldTagValues.onTagSubmitted,
              );
            },
          ),
        ],
      ),
    );
  }

  Future getImage(ImageSource img, context) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    if (xfilePick != null) {
      personalInfoController.galleryFile = File(pickedFile!.path);
      personalInfoController.xFileImage = xfilePick;
      setState(() {});
    } else {
      snackBar(context: context, text: "Nothing is Selected");
    }
    setState(() {});
  }

  Widget zoneTag() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Select Zone".tr,
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: FontFamily.sofiaRegular,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 5),
              Transform.translate(
                offset: const Offset(0, -3),
                child: Tooltip(
                  height: 50,
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: const Duration(seconds: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  textStyle: TextStyle(
                    fontFamily: FontFamily.gilroyMedium,
                    fontSize: 14,
                    letterSpacing: 0.5,
                    color: whiteColor,
                  ),
                  decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  message:
                      'You can add multiple Tags, but each tags must be followed by pressing Enter. '
                          .tr,
                  child: Transform.translate(
                    offset: const Offset(0, 3),
                    child: Icon(
                      CupertinoIcons.info_circle_fill,
                      color: appColor,
                      size: 22,
                    ),
                  ), //Text
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFieldTags(
            // textfieldTagsController: addlistofeventController.tegs,
            textfieldTagsController: personalInfoController.zoneTagController,
            initialTags: personalInfoController.zoneTagList,
            textSeparators: const [' ', ','],
            letterCase: LetterCase.normal,
            // validator: (String tag){
            //   if (tag == 'php'){
            //     return 'Php not allowed';
            //   }
            //   return null;
            // },
            inputFieldBuilder: (context, textFieldTagValues) {
              return TypeAheadField(
                controller: textFieldTagValues.textEditingController,
                focusNode: textFieldTagValues.focusNode,
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: textFieldTagValues.textEditingController,
                    focusNode: textFieldTagValues.focusNode,
                    style: TextStyle(
                      color: blackColor,
                      fontFamily: FontFamily.sofiaProRegular,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: ''.tr,
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: FontFamily.sofiaRegular,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: textFieldTagValues.tags.isNotEmpty
                          ? SingleChildScrollView(
                              controller:
                                  textFieldTagValues.tagScrollController,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: textFieldTagValues.tags.map((
                                  String tag,
                                ) {
                                  return InkWell(
                                    onTap: () {
                                      textFieldTagValues.onTagRemoved(tag);
                                    },
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: appColor,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        // gradient: appColor,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                        vertical: 5.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              tag,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              //print("$tag selected");
                                            },
                                          ),
                                          const SizedBox(width: 4.0),
                                          InkWell(
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: Color.fromARGB(
                                                255,
                                                233,
                                                233,
                                                233,
                                              ),
                                            ),
                                            onTap: () {
                                              textFieldTagValues.onTagRemoved(
                                                tag,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : null,
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
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onChanged: textFieldTagValues.onTagChanged,
                    onSubmitted: textFieldTagValues.onTagSubmitted,
                  );
                },
                emptyBuilder: (context) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "No Zone Found...!!!".tr,
                    style: TextStyle(
                      color: blackColor,
                      fontFamily: FontFamily.sofiaProRegular,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                onSelected: (item) {
                  // print(item.name);
                  setState(() {
                    personalInfoController.zoneTagList.add(item.id.toString());
                    print("+++++++++++ ${personalInfoController.zoneTagList}");
                  });
                  personalInfoController.zoneTagController =
                      item.name as StringTagController<String>;
                  print(
                    "+++++++++++++++ ${personalInfoController.zoneTagController}",
                  );
                },
                suggestionsCallback: (pattern) async {
                  return infoDetailController.infoDetailModel!.zoneData
                      .where(
                        (element) => element.name.toLowerCase().contains(
                              pattern.toLowerCase(),
                            ),
                      )
                      .toList();
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion.name,
                      style: TextStyle(
                        color: blackColor,
                        fontFamily: FontFamily.sofiaProRegular,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
