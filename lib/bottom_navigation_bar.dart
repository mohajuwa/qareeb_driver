// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, prefer_is_empty, unused_local_variable, prefer_interpolation_to_compose_strings, avoid_print, deprecated_member_use

import 'dart:async';
import 'dart:developer';

import 'package:dash_bubble/dash_bubble.dart';
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
        // _stopBubble();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        isAppClosing = true;
        _updateUserStatus();
        // _requestOverlayPermission(context);
        break;
      case AppLifecycleState.detached:
        // if (!_isAppClosing) {
        //   isAppClosing = false;
        //   _updateUserStatus();
        // }
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
                          // height: 21.5,
                          // width: 21.5,
                          color: appColor,
                        )
                      : SvgPicture.asset(
                          "assets/image/request.svg",
                          // height: 21.5,
                          // width: 21.5,
                          color: notifier.textColor,
                        ),
                  SizedBox(height: 4),
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
                  SizedBox(height: 4),
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
                  SizedBox(height: 4),
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
                  SizedBox(height: 4),
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

  Future<void> _requestOverlayPermission(BuildContext context) async {
    await _runMethod(context, () async {
      final isGranted = await DashBubble.instance.requestOverlayPermission();

      print("++++++++++++<><isGranted><><><><><><>><> ${isGranted}");
      if (isGranted == true) {
        // snackBar(context: context, text: "Background Permission Granted");
        _startBubble(
          context,
          bubbleOptions: BubbleOptions(
            // notificationIcon: 'github_bubble',
            // bubbleIcon: 'assets/image/app_logo.svg',
            // closeIcon: 'github_bubble',
            startLocationX: 0,
            startLocationY: 100,
            bubbleSize: 60,
            opacity: 1,
            enableClose: true,
            closeBehavior: CloseBehavior.following,
            distanceToClose: 100,
            enableAnimateToEdge: true,
            enableBottomShadow: true,
            keepAliveWhenAppExit: false,
          ),
          // notificationOptions: NotificationOptions(
          //   id: 1,
          //   title: 'Dash Bubble Playground',
          //   body: 'Dash Bubble service is running',
          //   channelId: 'dash_bubble_notification',
          //   channelName: 'Dash Bubble Notification',
          // ),
          onTap: openAppOrPlayStore,

          // onTapDown: (x, y) => snackBar(
          //   context: context,
          //   text:
          //   'Bubble Tapped Down on: ${_getRoundedCoordinatesAsString(x, y)}',
          // ),
          // onTapUp: (x, y) => snackBar(
          //   context: context,
          //   text:
          //   'Bubble Tapped Up on: ${_getRoundedCoordinatesAsString(x, y)}',
          // ),
          // onMove: (x, y) => snackBar(
          //   context: context,
          //   text:
          //   'Bubble Moved to: ${_getRoundedCoordinatesAsString(x, y)}',
          // ),
        );
      } else {
        snackBar(
          context: context,
          text: "Background Permission is not Granted",
        );
      }
    });
  }

  Future<void> _startBubble(
    BuildContext context, {
    BubbleOptions? bubbleOptions,
    NotificationOptions? notificationOptions,
    VoidCallback? onTap,
    Function(double x, double y)? onTapDown,
    Function(double x, double y)? onTapUp,
    Function(double x, double y)? onMove,
  }) async {
    await _runMethod(context, () async {
      final hasStarted = await DashBubble.instance.startBubble(
        bubbleOptions: bubbleOptions,
        notificationOptions: notificationOptions,
        onTap: onTap,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onMove: onMove,
      );
    });
  }

  Future<void> _runMethod(
    BuildContext context,
    Future<void> Function() method,
  ) async {
    try {
      await method();
    } catch (error) {
      log(name: 'Dash Bubble Playground', error.toString());
      snackBar(context: context, text: 'Error: ${error.runtimeType}');
    }
  }

  String _getRoundedCoordinatesAsString(double x, double y) {
    return '${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)}';
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
            _stopBubble();
          });
        });
      } else {
        // // Redirect to the Play Store if the app is not installed
        // await LaunchApp.openApp(
        //   androidPackageName: 'com.android.vending',
        //   // iosUrlScheme: 'itms-apps://itunes.apple.com/app/id123456789', // Example for iOS
        //   iosUrlScheme: 'https://play.google.com/apps/testing/com.xcamp.organizers', // Example for iOS
        //   appStoreLink: 'https://play.google.com/apps/testing/com.xcamp.organizers',
        // );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _stopBubble() async {
    await _runMethod(context, () async {
      final hasStopped = await DashBubble.instance.stopBubble();

      // snackBar(context: context, text: 'ZippyGo Captain stop running in background');

      // SnackBars.show(
      //   context: context,
      //   status: SnackBarStatus.success,
      //   message: hasStopped ? 'Bubble Stopped' : 'Bubble has not Stopped',
      // );
    });
  }
}
