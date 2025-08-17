// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, prefer_is_empty, unused_local_variable, prefer_interpolation_to_compose_strings, avoid_print, deprecated_member_use

import 'dart:async';
import 'dart:developer';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qareeb/screen/earning/my_earning.dart';
import 'package:qareeb/screen/home/home_screen.dart';
import 'package:qareeb/screen/rating/rating_screen.dart';
import 'package:qareeb/screen/wallet/wallet_screen.dart';
import 'package:qareeb/utils/colors.dart';
import 'package:qareeb/utils/font_family.dart';
import 'package:qareeb/widget/common.dart';
import 'package:qareeb/widget/dark_light_mode.dart';
import 'controller/background_message_controller.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

int currentIndexBottom = 0;
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class _BottomBarScreenState extends State<BottomBarScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabController;
  BackGroundMessageController backGroundMessageController = Get.put(
    BackGroundMessageController(),
  );

  List<Widget> myChildren = [
    HomeScreen(),
    MyEarning(),
    RatingScreen(),
    WalletScreen(),
  ];

  @override
  void initState() {
    getDarkMode();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: currentIndexBottom,
    );
    tabController.addListener(() {
      setState(() {
        currentIndexBottom = tabController.index;
      });
    });
  }

  bool isAppClosing = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        isAppClosing = false;
        _closeOverlay();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        isAppClosing = true;
        _updateUserStatus();
        _requestOverlayPermission(context);
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _updateUserStatus() {
    backGroundMessageController.backgroundUpdateApi();
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
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: TabController(
          length: 4,
          vsync: this,
          initialIndex: currentIndexBottom,
        ),
        children: myChildren,
      ),
      bottomNavigationBar: BottomAppBar(
        color: notifier.containerColor,
        child: TabBar(
          onTap: (index) {
            setState(() {
              currentIndexBottom = index;
            });
          },
          indicator: UnderlineTabIndicator(
            insets: EdgeInsets.only(bottom: 52),
            borderSide: BorderSide(color: notifier.containerColor, width: 2),
          ),
          labelColor: Colors.blueAccent,
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelColor: Colors.grey,
          controller: TabController(
            length: 4,
            vsync: this,
            initialIndex: currentIndexBottom,
          ),
          padding: const EdgeInsets.symmetric(vertical: 6),
          tabs: [
            Tab(
              child: Column(
                children: [
                  currentIndexBottom == 0
                      ? SvgPicture.asset(
                          "assets/image/request.svg",
                          color: appColor,
                        )
                      : SvgPicture.asset(
                          "assets/image/request.svg",
                          color: notifier.textColor,
                        ),
                  SizedBox(height: 2),
                  Text(
                    "Request".tr,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: FontFamily.sofiaProBold,
                      color: currentIndexBottom == 0
                          ? appColor
                          : notifier.textColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Column(
                children: [
                  currentIndexBottom == 1
                      ? SvgPicture.asset(
                          "assets/image/earning_fill.svg",
                          color: appColor,
                        )
                      : SvgPicture.asset(
                          "assets/image/earning.svg",
                          color: notifier.textColor,
                        ),
                  SizedBox(height: 2),
                  Text(
                    "My Earning".tr,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: FontFamily.sofiaProBold,
                      color: currentIndexBottom == 1
                          ? appColor
                          : notifier.textColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Column(
                children: [
                  if (currentIndexBottom == 2)
                    SvgPicture.asset(
                      "assets/image/rating_filled.svg",
                      color: appColor,
                    )
                  else
                    SvgPicture.asset(
                      "assets/image/rating.svg",
                      color: notifier.textColor,
                    ),
                  SizedBox(height: 2),
                  Text(
                    "My Review".tr,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: FontFamily.sofiaProBold,
                      color: currentIndexBottom == 2
                          ? appColor
                          : notifier.textColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Column(
                children: [
                  currentIndexBottom == 3
                      ? SvgPicture.asset(
                          "assets/image/wallet_filled.svg",
                          color: appColor,
                        )
                      : SvgPicture.asset(
                          "assets/image/wallet.svg",
                          color: notifier.textColor,
                        ),
                  SizedBox(height: 2),
                  Text(
                    "Wallet".tr,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: FontFamily.sofiaProBold,
                      color: currentIndexBottom == 3
                          ? appColor
                          : notifier.textColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MIGRATED: flutter_overlay_window methods replace dash_bubble
  Future<void> _requestOverlayPermission(BuildContext context) async {
    try {
      // Check if overlay permission is granted
      final status = await FlutterOverlayWindow.isPermissionGranted();

      print("++++++++++++<><isGranted><><><><><><>><> $status");

      if (status) {
        // Permission already granted, show overlay
        await _showOverlay();
      } else {
        // Request overlay permission
        final isGranted = await FlutterOverlayWindow.requestPermission();

        if (isGranted == true) {
          await _showOverlay();
        } else {
          snackBar(
            context: context,
            text: "Background Permission is not Granted",
          );
        }
      }
    } catch (error) {
      log(name: 'Flutter Overlay Window', error.toString());
      snackBar(context: context, text: 'Error: ${error.runtimeType}');
    }
  }

  Future<void> _showOverlay() async {
    try {
      await FlutterOverlayWindow.showOverlay(
        enableDrag: true,
        overlayTitle: "Qareeb Driver",
        overlayContent: 'Tap to return to app',
        flag: OverlayFlag.defaultFlag,
        visibility: NotificationVisibility.visibilityPublic,
        positionGravity: PositionGravity.auto,
        width: 100,
        height: 100,
      );
    } catch (e) {
      print('Error showing overlay: $e');
    }
  }

  // Listen for overlay taps (you'll need to set this up in your main.dart)
  void _setupOverlayListener() {
    FlutterOverlayWindow.overlayListener.listen((data) {
      log("Overlay tapped: $data");
      if (data == 'overlay_tap') {
        openAppOrPlayStore();
      }
    });
  }

  Future<void> openAppOrPlayStore() async {
    try {
      // Check if the app is installed
      bool isInstalled = await LaunchApp.isAppInstalled(
        androidPackageName: 'com.qareeb.rider',
      );

      if (isInstalled) {
        // Open the app if it's installed
        await LaunchApp.openApp(
          androidPackageName: 'com.qareeb.rider',
        );

        Timer(const Duration(seconds: 2), () {
          print("22222222222222222222222222 TIMER");
          setState(() {
            _closeOverlay();
          });
        });
      } else {
        // App not installed - you can add Play Store redirect logic here
        print('App not installed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _closeOverlay() async {
    try {
      final result = await FlutterOverlayWindow.closeOverlay();
      print('Overlay closed: $result');
    } catch (e) {
      print('Error closing overlay: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
    super.dispose();
  }
}
