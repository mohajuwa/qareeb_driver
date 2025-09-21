// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qareeb/screen/auth_screen/login_screen.dart';
import 'package:qareeb/utils/colors.dart';
import 'package:qareeb/utils/font_family.dart';

import '../../bottom_navigation_bar.dart';

var lat;
var long;
var address;

var movingLat;
var movingLong;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getCurrentLatAndLong();
    super.initState();
  }

  getCurrentLatAndLong() async {
    print('PRATIK_1');
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    print('PRATIK_2');
    if (permission == LocationPermission.denied) {
      print('PRATIK_3');
      if (Platform.isAndroid) {
        print('PRATIK_4');
        SystemNavigator.pop();
        print('PRATIK_5');
      } else if (Platform.isIOS) {
        print('PRATIK_6');
        exit(0);
      }
    }
    print('PRATIK_7');

    var currentLocation = await locateUser();

    setState(() {
      // print("  7 7 7 7 7 7 7 7 7 7 7 ${currentLocation.latitude}");
      // print("  7 7 7 7 7 7 7 7 7 7 7 ${currentLocation.longitude}");
      print('PRATIK_8');

      lat = currentLocation.latitude;
      long = currentLocation.longitude;
      print('PRATIK_9');

      initialization();
      print('PRATIK_10');
    });
  }

  void initialization() async {
    bool isLogin = await loginSharedPreferencesGet();
    await Future.delayed(const Duration(seconds: 2), () {
      if (isLogin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomBarScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- LAYOUT CORRECTION ---
    return Scaffold(
      backgroundColor: whiteColor,
      // 1. Use Center to perfectly center the content on the screen.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 2. Give the SVG a specific height to prevent it from expanding infinitely.
            SvgPicture.asset(
              "assets/image/app_logo.svg",
              height: 150,
            ),
            const SizedBox(height: 10),
            Text(
              "QareebGo",
              style: TextStyle(
                color: appColor,
                fontSize: 24,
                fontFamily: FontFamily.sofiaProBold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Be the Captain of Every Journey".tr,
              style: TextStyle(
                color: appColor,
                fontSize: 13.5,
                fontFamily: FontFamily.sofiaProBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void loginSharedPreferencesSet(bool value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool("UserLogin", value);
}

Future<bool> loginSharedPreferencesGet() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool value = preferences.getBool("UserLogin") ?? true;
  return value;
}

Future<Position> locateUser() async {
  return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}
