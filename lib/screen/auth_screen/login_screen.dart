import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:qareeb/bottom_navigation_bar.dart';
import 'package:qareeb/controller/login_controller.dart';
import 'package:qareeb/controller/mobile_check_controller.dart';
import 'package:qareeb/controller/msg_otp_controller.dart';
import 'package:qareeb/controller/otp_get_controller.dart';
import 'package:qareeb/screen/auth_screen/bank_info_screen.dart';
import 'package:qareeb/screen/auth_screen/otp_screen.dart';
import 'package:qareeb/screen/auth_screen/personal_info.dart';
import 'package:qareeb/screen/auth_screen/vechile_info.dart';
import 'package:qareeb/screen/auth_screen/verification_process.dart';
import 'package:qareeb/utils/colors.dart';
import 'package:qareeb/widget/common.dart';
import '../../controller/twilio_otp_controller.dart';
import '../../utils/font_family.dart';
import 'final_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());
  MobileCheckController mobileCheckController = Get.put(
    MobileCheckController(),
  );
  OtpGetController otpGetController = Get.put(OtpGetController());
  MsgOtpController msgOtpController = Get.put(MsgOtpController());
  TwilioOtpController twilioOtpController = Get.put(TwilioOtpController());

  PageController _pageController = PageController();

  void _handlingOnPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  List<Widget> _buildSlides() {
    return _slides.map(_buildSlide).toList();
  }

  int _currentPage = 0;

  List<Slide> _slides = [];

  @override
  void initState() {
    _currentPage = 0;

    _slides = [
      Slide(
        "assets/image/rider1st.json",
        "Welcome to Your Driving Journey!".tr,
        "Start earning by connecting with riders near you".tr,
      ),
      Slide(
        "assets/image/rider2nd.json",
        "Get Ready to Drive and Earn".tr,
        "Hit the road, accept rides, and watch your earnings grow".tr,
      ),
      Slide(
        "assets/image/rider3rd.json",
        "Unlock Your Earning Potential".tr,
        "Drive on your terms and maximize your income with every ride.".tr,
      ),
    ];

    _pageController = PageController(initialPage: _currentPage);
    super.initState();
  }

  Widget _buildPageIndicator() {
    Row row = const Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
    for (int i = 0; i < _slides.length; i++) {
      row.children.add(_buildPageIndicatorItem(i));
      if (i != _slides.length - 1) row.children.add(const SizedBox(width: 10));
    }
    return row;
  }

  Widget _buildPageIndicatorItem(int index) {
    return Container(
      width: index == _currentPage ? 30 : 8,
      height: index == _currentPage ? 8 : 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: index == _currentPage ? whiteColor : whiteColor.withOpacity(0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // height: 250,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Sign In".tr,
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 23,
                    fontFamily: FontFamily.sofiaProBold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Phone Number".tr,
                style: TextStyle(
                  color: blackColor,
                  fontSize: 15,
                  fontFamily: FontFamily.sofiaProBold,
                ),
              ),
              const SizedBox(height: 8),
              IntlPhoneField(
                controller: loginController.mobileController,
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
                  counterText: "",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.4),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  hintText: "Enter mobile number".tr,
                  hintStyle: TextStyle(
                    fontFamily: FontFamily.sofiaProRegular,
                    fontSize: 14,
                    color: Colors.grey.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColor, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                flagsButtonPadding: EdgeInsets.zero,
                showCountryFlag: false,
                showDropdownIcon: false,
                initialCountryCode: 'IN',
                dropdownTextStyle: TextStyle(
                  fontFamily: FontFamily.sofiaProRegular,
                  fontSize: 14,
                  color: blackColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                onChanged: (number) {
                  setState(() {
                    loginController.ccode = number.countryCode;

                    // passwordController.text.isEmpty ? passwordvalidate = true : false;
                  });
                },
              ),
              loginController.mobileCheck == true
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 13),
                        TextFormField(
                          controller: loginController.passwordController,
                          obscureText: loginController.obscureText,
                          cursorColor: appColor,
                          style: TextStyle(
                            fontFamily: FontFamily.sofiaProRegular,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                            letterSpacing: 0.3,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  loginController.obscureText =
                                      !loginController.obscureText;
                                });
                              },
                              child: loginController.obscureText == false
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
                            contentPadding: const EdgeInsets.only(
                              top: 15,
                              left: 12,
                            ),
                            hintText: "Enter Password".tr,
                            hintStyle: TextStyle(
                              fontFamily: FontFamily.sofiaProRegular,
                              fontSize: 15,
                              color: Colors.grey.withOpacity(0.4),
                              letterSpacing: 0.3,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: appColor, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 13),
              Transform.translate(
                offset: const Offset(-15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 1,
                      child: Checkbox(
                        value: loginController.check,
                        side: const BorderSide(color: Color(0xffC5CAD4)),
                        activeColor: appColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: (newBool) async {
                          setState(() {
                            loginController.checkTermsAndCondition(newBool);
                          });
                          // save('Remember', true);
                        },
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "By Singing up I agree to ".tr,
                              style: TextStyle(
                                fontSize: 12,
                                color: greyText,
                                fontFamily: FontFamily.sofiaProRegular,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "Terms Of Use ".tr,
                              style: TextStyle(
                                fontSize: 12,
                                color: appColor,
                                fontFamily: FontFamily.sofiaProBold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "and".tr,
                              style: TextStyle(
                                fontSize: 12,
                                color: greyText,
                                fontFamily: FontFamily.sofiaProRegular,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Text(
                          "Privacy Policy".tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: appColor,
                            fontFamily: FontFamily.sofiaProBold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              GetBuilder<LoginController>(
                builder: (loginController) {
                  return loginController.isLoading
                      ? button(
                          text: "CONTINUE".tr,
                          color: appColor,
                          onPress: () {
                            if (loginController
                                .mobileController.text.isNotEmpty) {
                              if (loginController.check == true) {
                                mobileCheckController
                                    .mobileCheckApi(
                                  context: context,
                                  primaryCode: loginController.ccode,
                                  primaryPhone:
                                      loginController.mobileController.text,
                                  secondCode: "",
                                  secondPhone: "",
                                )
                                    .then((value) {
                                  Map<String, dynamic> loginValue1 =
                                      json.decode(value);

                                  if (loginValue1["Result"] == false &&
                                      loginValue1["status"] == "1") {
                                    otpGetController
                                        .otpGetApi(context: context)
                                        .then((value) {
                                      if (value["Result"] == true &&
                                          value["message"] == "MSG91") {
                                        msgOtpController
                                            .msgOtpApi(
                                          context: context,
                                          phone:
                                              "${loginController.ccode}${loginController.mobileController.text}",
                                        )
                                            .then((value) {
                                          Map<String, dynamic> msgOtp =
                                              json.decode(
                                            value,
                                          );
                                          if (msgOtp["Result"] == true) {
                                            Get.to(
                                              OtpScreen(
                                                otpCode:
                                                    msgOtp["otp"].toString(),
                                              ),
                                            );
                                            loginController.isLoading = true;
                                            setState(() {});
                                          }
                                        });
                                      } else if (value["Result"] == true &&
                                          value["message"] == "Twilio") {
                                        twilioOtpController
                                            .twilioOtpApi(
                                          context: context,
                                          phone:
                                              "${loginController.ccode}${loginController.mobileController.text}",
                                        )
                                            .then((value) {
                                          Map<String, dynamic> twilioOtp =
                                              json.decode(
                                            value,
                                          );
                                          if (twilioOtp["Result"] == true) {
                                            Get.to(
                                              OtpScreen(
                                                otpCode:
                                                    twilioOtp["otp"].toString(),
                                              ),
                                            );
                                            loginController.isLoading = true;
                                            setState(() {});
                                          }
                                        });
                                      } else if (value["Result"] == true &&
                                          value["message"] == "No Auth") {
                                        Get.offAll(
                                          PersonalInfo(
                                            primaryMobile: loginController
                                                .mobileController.text,
                                            primaryCode: loginController.ccode,
                                          ),
                                        );
                                        loginController.isLoading = true;
                                        setState(() {});
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      loginController.mobileCheck = true;
                                    });
                                    if (loginController.passwordController.text
                                            .isNotEmpty &&
                                        loginController
                                            .mobileController.text.isNotEmpty) {
                                      loginController
                                          .loginApi(
                                        context: context,
                                        cCode: loginController.ccode,
                                        phone: loginController
                                            .mobileController.text,
                                        password: loginController
                                            .passwordController.text,
                                      )
                                          .then((value1) {
                                        Map<String, dynamic> loginValue =
                                            json.decode(
                                          value1,
                                        );
                                        if (loginValue["Result"] == true &&
                                            loginValue["status"] == "0") {
                                          Get.offAll(
                                            const BottomBarScreen(),
                                          );
                                          loginController.isLoading = true;
                                          setState(() {});
                                        } else if (loginValue["Result"] ==
                                                false &&
                                            loginValue["status"] == "2") {
                                          Get.offAll(
                                            const VehicleInfoScreen(),
                                          );
                                          loginController.isLoading = true;
                                          setState(() {});
                                        } else if (loginValue["Result"] ==
                                                false &&
                                            loginValue["status"] == "3") {
                                          Get.offAll(
                                            const BankInfoScreen(),
                                          );
                                          loginController.isLoading = true;
                                          setState(() {});
                                        }
                                        if (loginValue["Result"] == false &&
                                            loginValue["status"] == "4") {
                                          Get.offAll(
                                            const VerificationProcessScreen(),
                                          );
                                          loginController.isLoading = true;
                                          setState(() {});
                                        } else if (loginValue["Result"] ==
                                                false &&
                                            loginValue["status"] == "5") {
                                          Get.offAll(
                                            const FinalVerificationScreen(),
                                          );
                                          loginController.isLoading = true;
                                          setState(() {});
                                        } else if (loginValue["Result"] ==
                                                false &&
                                            loginValue["status"] == "6") {
                                          setState(() {
                                            loginController.mobileCheck = false;
                                            loginController.isLoading = true;
                                            loginController
                                                .passwordController.text = "";
                                          });
                                        }
                                      });
                                    } else {
                                      snackBar(
                                        context: context,
                                        text: "Enter Password".tr,
                                      );
                                    }
                                  }
                                });
                              } else {
                                setState(() {
                                  loginController.mobileCheck = false;
                                });
                                snackBar(
                                  context: context,
                                  text: "Please Accept Terms and Conditions".tr,
                                );
                              }
                            } else {
                              setState(() {
                                loginController.mobileCheck = false;
                              });
                              loginController.passwordController.clear();
                              snackBar(
                                context: context,
                                text: "Enter Mobile Number".tr,
                              );
                            }
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(color: appColor),
                        );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: _handlingOnPageChanged,
              physics: const BouncingScrollPhysics(),
              children: _buildSlides(),
            ),
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: _buildPageIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(Slide slide) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: appColor,
      body: Column(
        children: <Widget>[
          Container(
            height: Get.height * 0.40,
            width: Get.width,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: Get.size.height * 0.1),
            padding: const EdgeInsets.all(10),
            child: Lottie.asset(slide.image),
          ),
          Text(
            slide.heading,
            style: TextStyle(
              color: whiteColor,
              fontSize: 21,
              fontFamily: FontFamily.sofiaProBold,
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              slide.subtext,
              style: TextStyle(
                color: whiteColor,
                fontSize: 18,
                fontFamily: FontFamily.sofiaProBold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class Slide {
  String image;
  String heading;
  String subtext;

  Slide(this.image, this.heading, this.subtext);
}
