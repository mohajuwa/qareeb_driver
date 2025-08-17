// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:qareeb/screen/auth_screen/login_screen.dart';
import 'package:qareeb/screen/auth_screen/splash_screen.dart';
import 'package:qareeb/screen/home/language_screen.dart';
import 'package:qareeb/screen/home/past_request_screen.dart';
import 'package:qareeb/screen/home/ride_complete_screen.dart';
import 'package:qareeb/screen/home/sound_player.dart';
import 'package:qareeb/screen/map/map_request_screen.dart';
import '../../bottom_navigation_bar.dart';
import '../../config/config.dart';
import '../../config/data_store.dart';
import '../../controller/check_vehicle_request_controller.dart';
import '../../controller/delete_account_controller.dart';
import '../../controller/request_detail_controller.dart';
import '../../controller/update_location_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:ui' as ui;
import '../../widget/common.dart';
import '../../widget/dark_light_mode.dart';
import '../map/map_location_update_controller.dart';
import '../map/map_ride_screen.dart';
import 'my_account_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool darkMode = false;

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late IO.Socket socket;

  @override
  void initState() {
    notificationSoundPlayer.stopNotificationSound();
    getDarkMode();
    fetchAppVersion();
    socketConnect();
    print("------------- ${isTracking}");
    print("ndjfgdfvdjfgfgbfbvfug ${getData.read("OnOfStatus")}");
    getData.read("OnOfStatus") == 0 || getData.read("OnOfStatus") == null
        ? mapLocationUpdateController.sendCurrentLocation()
        : mapLocationUpdateController.startLiveTracking();
    super.initState();
  }

  UpdateLocationController updateLocationController = Get.put(
    UpdateLocationController(),
  );
  CheckVehicleRequestController checkVehicleRequestController = Get.put(
    CheckVehicleRequestController(),
  );
  MapLocationUpdateController mapLocationUpdateController = Get.put(
    MapLocationUpdateController(),
  );

  socketConnect() async {
    socket = IO.io(Config.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    _connectSocket();
    checkVehicleRequestController.checkVehicleApi(
      uid: getData.read("UserLogin")["id"].toString(),
    );
  }

  _connectSocket() {
    socket.off('vehiclerequest');
    socket.off('AcceRemoveOther');
    socket.off(
      'Vehicle_Ride_Cancel${getData.read("UserLogin")["id"].toString()}',
    );
    socket.off('RequestTimeOut');
    socket.off('removeotherdata${getData.read("UserLogin")["id"].toString()}');

    socket.onConnect((data) => print('Connection established'));
    socket.onConnectError((data) => print('Connect Error: $data'));
    socket.onDisconnect((data) => print('Socket.IO server disconnected'));

    socket.on('vehiclerequest', (request) {
      notificationSoundPlayer.stopNotificationSound();
      print("-----request122334------------ ${request}");
      print("-----request------------ ${request["requestid"].toString()}");
      print("-----id------------ ${request["driverid"]}");

      if (request["driverid"].toString().contains(
            getData.read("UserLogin")["id"].toString(),
          )) {
        // requestDetailController.requestDetailApi(requestId: request["requestid"].toString()).then((value) {
        //   Map<String, dynamic> mapData = json.decode(value);
        //   print("++++++++++++++++ ${mapData}");
        //
        //   if(mapData["Result"] == true){
        //     notificationSoundPlayer.stopNotificationSound();
        //     Timer(const Duration(seconds: 2), () {
        //       print("22222222222222222222222222 TIMER");
        //       Get.to(MapScreen(requestID: request["requestid"].toString()));
        //       checkVehicleRequestController.checkVehicleApi(uid: getData.read("UserLogin")["id"].toString());
        //     },);
        //   }else{
        //     // snackBar(context: context, text: "");
        //   }
        //
        // });
        notificationSoundPlayer.stopNotificationSound();
        Timer(const Duration(seconds: 2), () {
          print("22222222222222222222222222 TIMER");
          Get.to(MapScreen(requestID: request["requestid"].toString()));
          checkVehicleRequestController.checkVehicleApi(
            uid: getData.read("UserLogin")["id"].toString(),
          );
        });
      } else {
        print("UID Not Found");
      }
    });

    socket.on(
      "Vehicle_Ride_Cancel${getData.read("UserLogin")["id"].toString()}",
      (status) {
        print("++++++status++++++++++++++++ ${status}");
        if (status["driverid"].toString().contains(
              getData.read("UserLogin")["id"].toString(),
            )) {
          notificationSoundPlayer.stopNotificationSound();
          currentIndexBottom = 0;
          // setState(() {
          //
          // });
          Get.offAll(const BottomBarScreen());
        } else {
          print("UID Not Found");
        }
      },
    );

    socket.on("AcceRemoveOther", (request) {
      print("++++++request123456789++++++++++++++++ ${request}");
      if (request["driverid"].toString().contains(
            getData.read("UserLogin")["id"].toString(),
          )) {
        notificationSoundPlayer.stopNotificationSound();
        currentIndexBottom = 0;
        // setState(() {
        //
        // });
        Get.offAll(const BottomBarScreen());
      } else {
        print("UID Not Found");
      }
    });

    socket.on("RequestTimeOut", (status) {
      print("--++++++-++658455554555 ${status}");
      if (status["driverid"].toString().contains(
            getData.read("UserLogin")["id"].toString(),
          )) {
        checkVehicleRequestController.checkVehicleApi(
          uid: getData.read("UserLogin")["id"].toString(),
        );
      } else {
        print("UID Not Found");
      }
    });

    socket.on('removeotherdata${getData.read("UserLogin")["id"].toString()}', (
      request,
    ) {
      print("-----request------------ ${request["requestid"].toString()}");
      print("-----id------------ ${request["driverid"]}");
      if (request["driverid"].toString().contains(
            getData.read("UserLogin")["id"].toString(),
          )) {
        checkVehicleRequestController.checkVehicleApi(
          uid: getData.read("UserLogin")["id"].toString(),
        );
      } else {
        print("UID Not Found");
      }
    });
  }

  @override
  void dispose() {
    checkVehicleRequestController.isLoading = false;
    // socket.disconnect();
    // socket.dispose();
    // socket.close();
    // socket.onDisconnect((data) => print('Socket.IO server disconnected'));
    socket.off('vehiclerequest');
    socket.off('AcceRemoveOther');
    socket.off(
      'Vehicle_Ride_Cancel${getData.read("UserLogin")["id"].toString()}',
    );
    socket.off('RequestTimeOut');
    socket.off('removeotherdata${getData.read("UserLogin")["id"].toString()}');
    super.dispose();
  }

  RequestDetailController requestDetailController = Get.put(
    RequestDetailController(),
  );
  AccountDeleteController accountDeleteController = Get.put(
    AccountDeleteController(),
  );
  final NotificationSoundPlayer notificationSoundPlayer =
      NotificationSoundPlayer();

  int isTracking = 0;
  bool isLoading = false;

  late ColorNotifier notifier;

  getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previousState = prefs.getBool("setIsDark");
    if (previousState == null) {
      notifier.setIsDark = false;
    } else {
      notifier.setIsDark = previousState;
      darkMode = previousState;
    }
  }

  String appVersion = '';
  String buildNumber = '';

  Future<void> fetchAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: notifier.background,
      drawer: Drawer(
        backgroundColor: notifier.background,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: appColor),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: appColor),
                accountName: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "${getData.read("UserLogin")["first_name"]} ${getData.read("UserLogin")["last_name"]}",
                    style: TextStyle(
                      fontFamily: FontFamily.sofiaProBold,
                      letterSpacing: 0.5,
                      fontSize: 15,
                    ),
                  ),
                ),
                accountEmail: Text(
                  "${getData.read("UserLogin")["primary_ccode"]} ${getData.read("UserLogin")["primary_phoneNo"]}",
                  style: TextStyle(
                    fontFamily: FontFamily.sofiaProBold,
                    letterSpacing: 0.5,
                    fontSize: 15,
                  ),
                ),
                currentAccountPictureSize: const Size.square(50),
                currentAccountPicture: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(color: Colors.grey.shade300),
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(65),
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/image/ezgif.com-crop.gif",
                      placeholderCacheWidth: 50,
                      placeholderCacheHeight: 50,
                      image:
                          "${Config.imageUrl}${getData.read("UserLogin")["profile_image"]}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            homeDrawer(
              context: context,
              onTap: () {
                Get.back();
                Get.to(const BottomBarScreen());
              },
              image: "assets/image/current_booking.svg",
              title: "Current Booking".tr,
            ),
            homeDrawer(
              context: context,
              onTap: () {
                Get.to(const HistoryScreen());
              },
              image: "assets/image/drawer.svg",
              title: "History".tr,
            ),
            homeDrawer(
              context: context,
              onTap: () {
                Get.back();
                Get.to(const MyAccountScreen());
              },
              image: "assets/image/my_account.svg",
              title: "My Account".tr,
            ),
            homeDrawer(
              context: context,
              onTap: () {
                Get.back();
                Get.to(const LanguageScreen());
              },
              image: "assets/image/globe-earth.svg",
              title: "Language".tr,
            ),
            ListTile(
              minLeadingWidth: 0,
              onTap: () {},
              visualDensity: VisualDensity.compact,
              leading: SizedBox(
                height: 25,
                width: 25,
                child: SvgPicture.asset(
                  "assets/image/moon.svg",
                  color: appColor,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                "Dark Mode".tr,
                style: TextStyle(
                  fontFamily: FontFamily.sofiaProBold,
                  letterSpacing: 0.5,
                  fontSize: 15,
                  color: notifier.textColor,
                  height: 1.4,
                ),
              ),
              trailing: Transform.scale(
                scale: 0.6,
                child: Transform.translate(
                  offset: const Offset(25, 0),
                  child: CupertinoSwitch(
                    trackColor: greyText,
                    activeColor: appColor,
                    thumbColor: Colors.white,
                    value: darkMode,
                    onChanged: (bool value) async {
                      setState(() {
                        Get.back();
                        darkMode = value;
                      });
                      final prefs = await SharedPreferences.getInstance();
                      setState(() {
                        notifier.setIsDark = value;
                        prefs.setBool("setIsDark", value);
                      });
                    },
                  ),
                ),
              ),
            ),
            ListTile(
              minLeadingWidth: 0,
              onTap: () {
                Navigator.pop(context);
                loginSharedPreferencesSet(true);
                mapLocationUpdateController.stopLiveTracking();
                updateLocationController
                    .updateLocationAPi(
                  lat: lat.toString(),
                  long: long.toString(),
                  status: "off",
                )
                    .then((value) {
                  print("+++++++++++++++++++ $value");
                  socket.emit('homemap', {
                    'uid': getData.read("UserLogin")["id"].toString(),
                    'lat': lat.toString(),
                    'long': long.toString(),
                    'status': "off",
                  });
                  save("OnOfStatus", isTracking);
                  Get.offAll(const LoginScreen());
                  checkVehicleRequestController.isLoading = false;
                  setState(() {});
                });
              },
              visualDensity: VisualDensity.compact,
              leading: SizedBox(
                height: 25,
                width: 25,
                child: SvgPicture.asset(
                  "assets/image/log-out.svg",
                  color: Colors.red,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                "LogOut".tr,
                style: TextStyle(
                  fontFamily: FontFamily.sofiaProBold,
                  letterSpacing: 0.5,
                  fontSize: 15,
                  color: Colors.red,
                  height: 1.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
                bottom: 20,
              ),
              child: SizedBox(
                height: 49,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: const WidgetStatePropertyAll(0),
                    overlayColor: const WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    backgroundColor: const WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogBackgroundColor: notifier.containerColor,
                      customHeader: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset("assets/image/app_logo.svg"),
                      ),
                      btnCancel: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: button(
                          text: "Cancel",
                          color: Colors.red,
                          onPress: () {
                            Get.back();
                          },
                        ),
                      ),
                      btnOk: button(
                        text: "Yes, Remove",
                        color: appColor,
                        onPress: () {
                          accountDeleteController
                              .deleteAccountApi(context: context)
                              .then((value) {
                            Map<String, dynamic> data = json.decode(value);
                            if (data["Result"] == true) {
                              loginSharedPreferencesSet(true);
                              mapLocationUpdateController.stopLiveTracking();
                              updateLocationController
                                  .updateLocationAPi(
                                lat: lat.toString(),
                                long: long.toString(),
                                status: "off",
                              )
                                  .then((value) {
                                print("+++++++++++++++++++ $value");
                                socket.emit('homemap', {
                                  'uid': getData
                                      .read("UserLogin")["id"]
                                      .toString(),
                                  'lat': lat.toString(),
                                  'long': long.toString(),
                                  'status': "off",
                                });
                                save("OnOfStatus", isTracking);
                                Get.offAll(const LoginScreen());
                                checkVehicleRequestController.isLoading = false;
                                setState(() {});
                              });
                            } else {
                              snackBar(
                                context: context,
                                text: "${data["message"]}",
                              );
                            }
                          });
                        },
                      ),
                      dialogType: DialogType.warning,
                      body: Center(
                        child: Text(
                          'Are you sure you want to delete account?',
                          style: TextStyle(
                            fontFamily: FontFamily.sofiaProBold,
                            letterSpacing: 0.5,
                            fontSize: 15,
                            color: notifier.textColor,
                            height: 1.4,
                          ),
                        ),
                      ),
                      btnOkOnPress: () {},
                    ).show();
                  },
                  child: Text(
                    "Delete Account",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0.5,
                      fontFamily: FontFamily.sofiaProBold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "V 1.3".tr,
              style: TextStyle(
                fontFamily: FontFamily.sofiaProBold,
                fontSize: 15,
                color: greyText,
              ),
              textAlign: TextAlign.center,
            ),
            // Center(
            //   child: Text(
            //     'Version: $appVersion',
            //     style: TextStyle(
            //       fontFamily: FontFamily.sofiaProBold,
            //       fontSize: 15,
            //       color: greyText,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: notifier.containerColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: appColor),
          onPressed: () {
            setState(() {});
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: ToggleSwitch(
          minWidth: 90.0,
          cornerRadius: 20.0,
          activeBgColors: const [
            [Colors.red],
            [Colors.green],
          ],
          activeFgColor: Colors.white,
          inactiveBgColor: notifier.background,
          inactiveFgColor: notifier.textColor,
          initialLabelIndex: getData.read("OnOfStatus") ?? isTracking,
          totalSwitches: 2,
          fontSize: 14,
          centerText: true,
          customTextStyles: [
            TextStyle(
              fontFamily: FontFamily.sofiaProBold,
              letterSpacing: 0.5,
              fontSize: 15,
              height: 1.4,
            ),
          ],
          labels: const ['Offline', 'Online'],
          radiusStyle: true,
          onToggle: (index) {
            if (index != null) {
              setState(() {
                isTracking = index;
                print("+++++++++++++++++++ ${index}");
                if (isTracking == 1) {
                  print("------------- ${isTracking}");
                  mapLocationUpdateController.startLiveTracking();
                  save("OnOfStatus", isTracking);
                  print("+++++++++++ON+++++++++ ${getData.read("OnOfStatus")}");
                } else {
                  mapLocationUpdateController.stopLiveTracking();
                  mapLocationUpdateController.sendCurrentLocation();
                  save("OnOfStatus", isTracking);
                  print(
                    "+++++++++++OFF+++++++++ ${getData.read("OnOfStatus")}",
                  );
                }
              });
            }
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(const NotificationScreen());
            },
            child: Container(
              alignment: Alignment.center,
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: notifier.background,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.notifications, color: appColor, size: 22),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: GetBuilder<CheckVehicleRequestController>(
        builder: (checkVehicleRequestController) {
          return checkVehicleRequestController.isLoading
              ? checkVehicleRequestController
                      .checkVehicleRequestModel!.requestData.isNotEmpty
                  ? Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                          ),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: checkVehicleRequestController
                                      .checkVehicleRequestModel!
                                      .requestData
                                      .length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        notificationSoundPlayer
                                            .stopNotificationSound();
                                        checkVehicleRequestController
                                                    .checkVehicleRequestModel!
                                                    .requestData[index]
                                                    .status ==
                                                "0"
                                            ? Get.to(
                                                MapScreen(
                                                  requestID:
                                                      checkVehicleRequestController
                                                          .checkVehicleRequestModel!
                                                          .requestData[index]
                                                          .id
                                                          .toString(),
                                                ),
                                              )?.then((value) {
                                                isLoading = false;
                                                setState(() {});
                                              })
                                            : checkVehicleRequestController
                                                            .checkVehicleRequestModel!
                                                            .requestData[index]
                                                            .status ==
                                                        "1" ||
                                                    checkVehicleRequestController
                                                            .checkVehicleRequestModel!
                                                            .requestData[index]
                                                            .status ==
                                                        "2" ||
                                                    checkVehicleRequestController
                                                            .checkVehicleRequestModel!
                                                            .requestData[index]
                                                            .status ==
                                                        "3" ||
                                                    checkVehicleRequestController
                                                            .checkVehicleRequestModel!
                                                            .requestData[index]
                                                            .status ==
                                                        "5" ||
                                                    checkVehicleRequestController
                                                            .checkVehicleRequestModel!
                                                            .requestData[index]
                                                            .status ==
                                                        "6"
                                                ? requestDetailController
                                                    .requestDetailApi(
                                                    requestId:
                                                        checkVehicleRequestController
                                                            .checkVehicleRequestModel!
                                                            .requestData[index]
                                                            .id
                                                            .toString(),
                                                  )
                                                    .then((value) {
                                                    homeStatus = 1;
                                                    buttonStatus = 1;
                                                    setState(() {});
                                                    Get.to(
                                                      MapRideScreen(
                                                        requestId:
                                                            checkVehicleRequestController
                                                                .checkVehicleRequestModel!
                                                                .requestData[
                                                                    index]
                                                                .id
                                                                .toString(),
                                                        time: checkVehicleRequestController
                                                            .checkVehicleRequestModel!
                                                            .requestData[index]
                                                            .runningTime
                                                            .runTime
                                                            .toString(),
                                                        timeStatus:
                                                            checkVehicleRequestController
                                                                .checkVehicleRequestModel!
                                                                .requestData[
                                                                    index]
                                                                .runningTime
                                                                .status
                                                                .toString(),
                                                      ),
                                                    );
                                                    isLoading = false;
                                                    setState(() {});
                                                  })
                                                : checkVehicleRequestController
                                                            .checkVehicleRequestModel!
                                                            .requestData[index]
                                                            .status ==
                                                        "7"
                                                    ? Get.to(
                                                        RideCompleteScreen(
                                                          requestId:
                                                              checkVehicleRequestController
                                                                  .checkVehicleRequestModel!
                                                                  .requestData[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                          cID: checkVehicleRequestController
                                                              .checkVehicleRequestModel!
                                                              .requestData[
                                                                  index]
                                                              .cId
                                                              .toString(),
                                                          status: checkVehicleRequestController
                                                              .checkVehicleRequestModel!
                                                              .requestData[
                                                                  index]
                                                              .status
                                                              .toString(),
                                                        ),
                                                      )
                                                    : const SizedBox();
                                      },
                                      child: Container(
                                        // height: 150,
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 5,
                                          right: 8,
                                        ),
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          color: notifier.containerColor,
                                          borderRadius: BorderRadius.circular(
                                            13,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 70,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color: appColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                    checkVehicleRequestController
                                                        .checkVehicleRequestModel!
                                                        .requestData[index]
                                                        .name[0]
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 18,
                                                      fontFamily: FontFamily
                                                          .sofiaProBold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                SizedBox(
                                                  width: Get.width / 4,
                                                  // color: Colors.red,
                                                  child: Text(
                                                    checkVehicleRequestController
                                                        .checkVehicleRequestModel!
                                                        .requestData[index]
                                                        .name,
                                                    style: TextStyle(
                                                      color: notifier.textColor,
                                                      fontSize: 14,
                                                      fontFamily: FontFamily
                                                          .sofiaProRegular,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/image/rating_filled.svg",
                                                      color:
                                                          Colors.amber.shade800,
                                                    ),
                                                    Text(
                                                      "${checkVehicleRequestController.checkVehicleRequestModel!.requestData[index].rating}(${checkVehicleRequestController.checkVehicleRequestModel!.requestData[index].review})",
                                                      style: TextStyle(
                                                        color:
                                                            notifier.textColor,
                                                        fontSize: 14,
                                                        letterSpacing: 0.5,
                                                        fontFamily: FontFamily
                                                            .sofiaProRegular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 6),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RotatedBox(
                                                        quarterTurns: 2,
                                                        child: Icon(
                                                          CupertinoIcons
                                                              .location_north_fill,
                                                          size: 20,
                                                          color: appColor,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 6,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          "${checkVehicleRequestController.checkVehicleRequestModel!.requestData[index].pickAdd.title} ${checkVehicleRequestController.checkVehicleRequestModel!.requestData[index].pickAdd.subtitle}",
                                                          style: TextStyle(
                                                            color: notifier
                                                                .textColor,
                                                            fontSize: 13,
                                                            letterSpacing: 0.5,
                                                            fontFamily: FontFamily
                                                                .sofiaProBold,
                                                          ),
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 14),
                                                  ListView.separated(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        checkVehicleRequestController
                                                            .checkVehicleRequestModel!
                                                            .requestData[index]
                                                            .dropAdd
                                                            .length,
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            const SizedBox(
                                                      height: 14,
                                                    ),
                                                    itemBuilder:
                                                        (context, index1) {
                                                      return Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                            child: SvgPicture
                                                                .asset(
                                                              "assets/image/loaction_circle.svg",
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              "${checkVehicleRequestController.checkVehicleRequestModel!.requestData[index].dropAdd[index1].title} ${checkVehicleRequestController.checkVehicleRequestModel!.requestData[index].dropAdd[index1].subtitle}",
                                                              style: TextStyle(
                                                                color: greyText,
                                                                fontSize: 13,
                                                                letterSpacing:
                                                                    0.5,
                                                                height: 1.1,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .sofiaProBold,
                                                              ),
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const SizedBox(
                                                        width: 25,
                                                      ),
                                                      Text(
                                                        "${getData.read("Currency")}${double.parse("${checkVehicleRequestController.checkVehicleRequestModel!.requestData[index].price}")}",
                                                        style: TextStyle(
                                                          color: notifier
                                                              .textColor,
                                                          fontSize: 16,
                                                          fontFamily: FontFamily
                                                              .sofiaProBold,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        "${double.parse(checkVehicleRequestController.checkVehicleRequestModel!.requestData[index].perKmPrice).toStringAsFixed(1)}${getData.read("Currency")}/Km",
                                                        style: TextStyle(
                                                          color: notifier
                                                              .textColor,
                                                          fontSize: 16,
                                                          fontFamily: FontFamily
                                                              .sofiaProBold,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        "${double.parse(checkVehicleRequestController.checkVehicleRequestModel!.requestData[index].totKm).toStringAsFixed(1)} Km",
                                                        style: TextStyle(
                                                          color: appColor,
                                                          fontSize: 15,
                                                          fontFamily: FontFamily
                                                              .sofiaProBold,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
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
                            ),
                          ),
                        ),
                        isLoading == true
                            ? Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: BackdropFilter(
                                  filter: ui.ImageFilter.blur(
                                    sigmaX: 1.5,
                                    sigmaY: 1.5,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: appColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
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
                            "No Request Found!".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.sofiaProBold,
                              color: notifier.textColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Currently you don’t have request.".tr,
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

  Future<void> _requestOverlayPermission(BuildContext context) async {
    try {
      final status = await FlutterOverlayWindow.isPermissionGranted();

      if (status) {
        await _showOverlay();
      } else {
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

  Future<void> openAppOrPlayStore() async {
    try {
      bool isInstalled = await LaunchApp.isAppInstalled(
        androidPackageName: 'com.qareeb.rider',
      );

      if (isInstalled) {
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
}
