// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import 'package:qareeb/controller/login_controller.dart';
import 'package:qareeb/screen/auth_screen/personal_info.dart';
import 'package:qareeb/utils/colors.dart';
import 'package:qareeb/widget/common.dart';

import '../../controller/msg_otp_controller.dart';
import '../../controller/otp_get_controller.dart';
import '../../controller/twilio_otp_controller.dart';
import '../../utils/font_family.dart';

class OtpScreen extends StatefulWidget {
  late String otpCode;
  OtpScreen({
    Key? key,
    required this.otpCode,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  LoginController loginController = Get.put(LoginController());
  OtpGetController otpGetController = Get.put(OtpGetController());
  MsgOtpController msgOtpController = Get.put(MsgOtpController());
  TwilioOtpController twilioOtpController = Get.put(TwilioOtpController());

  int secondsRemaining = 30;
  bool enableResend = false;
  Timer? timer;

  @override
  void initState() {
    print("+++++++++++++++++++ ${widget.otpCode}");
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_sharp, size: 20, color: blackColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Verification Code".tr,
              style: TextStyle(
                color: blackColor,
                fontSize: 23,
                fontFamily: FontFamily.sofiaProBold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "We have sent the code verification to".tr,
              style: TextStyle(
                color: greyText,
                fontSize: 16,
                fontFamily: FontFamily.sofiaProRegular,
              ),
            ),
            Row(
              children: [
                Text(
                  "your number ".tr,
                  style: TextStyle(
                    color: greyText,
                    fontSize: 16,
                    fontFamily: FontFamily.sofiaProRegular,
                  ),
                ),
                Text(
                  "${loginController.ccode} ${loginController.mobileController.text}",
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontFamily: FontFamily.sofiaProRegular,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            OTPTextField(
              length: 6,
              controller: loginController.otpController,
              width: MediaQuery.of(context).size.width,
              otpFieldStyle: OtpFieldStyle(
                disabledBorderColor: greyText,
                enabledBorderColor: greyText,
                focusBorderColor: appColor,
              ),
              fieldWidth: 50,
              keyboardType: TextInputType.number,
              outlineBorderRadius: 8,
              style: TextStyle(
                fontFamily: FontFamily.sofiaRegular,
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: blackColor,
                letterSpacing: 0.3,
              ),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.box,
              onChanged: (value) {
                setState(() {
                  loginController.otpCode = value;
                });
              },
              onCompleted: (pin) {
                setState(() {
                  loginController.otpCode = pin;
                });
                // print("Completed: $pin");
              },
            ),
            const SizedBox(height: 20),
            enableResend
                ? const SizedBox()
                : Container(
                    height: 30,
                    alignment: Alignment.center,
                    child: Text(
                      " $secondsRemaining Seconds".tr,
                      style: TextStyle(
                        color: appColor,
                        fontFamily: FontFamily.gilroyBold,
                      ),
                    ),
                  ),
            const Spacer(),
            button(
              text: "CONTINUE".tr,
              color: appColor,
              onPress: () {
                if (loginController.otpCode.isNotEmpty) {
                  if (widget.otpCode == loginController.otpCode) {
                    Get.offAll(
                      PersonalInfo(
                        primaryMobile: loginController.mobileController.text,
                        primaryCode: loginController.ccode,
                      ),
                    );
                  } else {
                    snackBar(context: context, text: "Enter Correct OTP".tr);
                  }
                } else {
                  snackBar(context: context, text: "Please Enter OTP".tr);
                }
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn’t receive the code? ".tr,
                  style: TextStyle(
                    color: greyText,
                    fontSize: 16,
                    fontFamily: FontFamily.sofiaProRegular,
                  ),
                ),
                enableResend
                    ? InkWell(
                        onTap: () {
                          _resendCode();
                        },
                        child: Container(
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            "Resend".tr,
                            style: TextStyle(
                              color: appColor,
                              fontFamily: FontFamily.gilroyBold,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _resendCode() {
    otpGetController.otpGetApi(context: context).then((value) {
      if (value["Result"] == true && value["message"] == "MSG91") {
        msgOtpController
            .msgOtpApi(
          context: context,
          phone:
              "${loginController.ccode}${loginController.mobileController.text}",
        )
            .then((value) {
          Map<String, dynamic> msgOtp = json.decode(value);
          if (msgOtp["Result"] == true) {
            widget.otpCode = msgOtp["otp"].toString();
            print("--------------- ${widget.otpCode}");
            setState(() {});
          }
        });
      } else if (value["Result"] == true && value["message"] == "Twilio") {
        twilioOtpController
            .twilioOtpApi(
          context: context,
          phone:
              "${loginController.ccode}${loginController.mobileController.text}",
        )
            .then((value) {
          Map<String, dynamic> twilioOtp = json.decode(value);
          if (twilioOtp["Result"] == true) {
            widget.otpCode = twilioOtp["otp"].toString();
            setState(() {});
          }
        });
      }
    });
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
      startTimer();
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          enableResend = true;
          t.cancel();
        }
      });
    });
  }
}
