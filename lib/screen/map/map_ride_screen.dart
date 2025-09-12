// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:action_slider/action_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qareeb/screen/auth_screen/splash_screen.dart';
import 'package:qareeb/screen/home/home_screen.dart';
import 'package:qareeb/widget/common.dart';
import '../../bottom_navigation_bar.dart';
import '../../config/config.dart';
import '../../config/data_store.dart';
import '../../controller/cancel_request_controller.dart';
import '../../controller/cancel_request_reason_controller.dart';
import '../../controller/check_vehicle_request_controller.dart';
import '../../controller/i_am_here_controller.dart';
import '../../controller/notification_controller.dart';
import '../../controller/otp_ride_controller.dart';
import '../../controller/request_detail_controller.dart';
import '../../controller/ride_cancel_controller.dart';
import '../../controller/ride_start_controller.dart';
import '../../controller/time_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../widget/dark_light_mode.dart';
import '../chat/chat_screen.dart';
import '../home/ride_complete_screen.dart';
import 'map_location_update_controller.dart';

int timmer = 0;
int homeStatus = 0;

// Set<Marker> markers = {};
// Map<MarkerId, Marker> markers11 = {};
// Map<PolylineId, Polyline> polylines11 = {};
// List<LatLng> polylineCoordinates11 = [];

// List<LatLng> polylineCoordinates = [];
// Set<Polyline> polylines = {};

class MapRideScreen extends StatefulWidget {
  final String time;
  final String requestId;
  final String? timeStatus;
  const MapRideScreen(
      {super.key,
      required this.time,
      required this.requestId,
      this.timeStatus});

  @override
  State<MapRideScreen> createState() => _MapRideScreenState();
}

class _MapRideScreenState extends State<MapRideScreen> {
  late int countdownStart;
  late int remainingTime;
  Timer? timer;
  num addTime = 1000000000000000000;

  late ColorNotifier notifier;
  String themeForMap = "";

  getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previousState = prefs.getBool("setIsDark");
    if (previousState == null) {
      notifier.setIsDark = false;
      print("11111111lightl1111111111");
    } else {
      notifier.setIsDark = previousState;
      // _controller.future.then((value) {
      //   setState(() {
      //     DefaultAssetBundle.of(context).loadString("i_theme/dark_theme.json").then((style) {
      //       setState(() {
      //         value.setMapStyle(style);
      //       });
      //     },);
      //   });
      // },);
    }
  }

  @override
  void initState() {
    getDarkMode();
    mapThemeStyle();
    print(
        "++++++++++++++++++++++++darkMode+++++++++++++++++++++++++++++ ${darkMode}");
    print("********themeForMap************ $themeForMap");
    print("785335timeStatus68628898 ${widget.timeStatus}");
    super.initState();
    cancelRequestReasonController.cancelReasonApi(context: context);
    print('************homeStatus_0--------------- $homeStatus');
    socketConnect();
  }

  mapThemeStyle() {
    if (darkMode == true) {
      setState(() {
        DefaultAssetBundle.of(context)
            .loadString("i_theme/dark_theme.json")
            .then(
          (value) {
            setState(() {
              themeForMap = value;
            });
          },
        );
      });
    }
  }

  void startTimer() {
    timer?.cancel();
    timmer = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          requestDetailController.requestDetailModel!.requestData.status == "2"
              ? startTimerAdd()
              : timer.cancel();
        }
      });
    });
  }

  void startTimer1() {
    timer?.cancel();
    timmer = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime2 > 0) {
          remainingTime2--;
        } else {
          timer.cancel();
          requestDetailController.requestDetailModel!.requestData.status == "2"
              ? startTimerAdd1()
              : timer.cancel();
        }
      });
    });
  }

  void startTimerAdd() {
    timer?.cancel();
    timmer = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime < addTime) {
          print("********addTime********** ${addTime}");
          remainingTime++;
          timmer = remainingTime;
          // formatTime(remainingTime);
          print('++++++++++++++++------ (${timmer})');
          print("+++++++++++remainingTime++++++++++++++ ${remainingTime}");
        } else {
          timer.cancel();
        }
      });
    });
  }

  void startTimerAdd1() {
    timer?.cancel();
    timmer = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime2 < addTime) {
          print("********addTime********** ${addTime}");
          remainingTime2++;
          timmer = remainingTime2;
          // formatTime(remainingTime);
          print('++++++++++++++++------ (${timmer})');
          print("+++++++++++remainingTime++++++++++++++ ${remainingTime2}");
        } else {
          timer.cancel();
        }
      });
    });
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String formatTime2(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingTime2 = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingTime2.toString().padLeft(2, '0')}';
  }

  late IO.Socket socket;

  socketConnect() async {
    socket = IO.io(Config.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    _connectSocket();

    requestDetailController
        .requestDetailApi(requestId: widget.requestId)
        .then((value) {
      Map<String, dynamic> mapData = json.decode(value);

      // requestDetailController.requestDetailModel!.requestData.biddingStatus == "1" ? bottomSheetTime(requestID: widget.requestId.toString()) : const SizedBox();

      if (mapData["request_data"]["status"] == "1") {
        var pickLatLon = mapData["request_data"]["pick_latlon"];

        if (pickLatLon is List) {
          List<dynamic> dropOffPointsDynamic = pickLatLon;
          print("------List------------- $dropOffPointsDynamic");

          mapLocationUpdateController.dropOffPoints =
              dropOffPointsDynamic.map((item) {
            return PointLatLng(
              double.parse(item["latitude"].toString()),
              double.parse(item["longitude"].toString()),
            );
          }).toList();
        } else if (pickLatLon is Map) {
          // Handle the case where pick_latlon is a single object
          mapLocationUpdateController.dropOffPoints = [
            PointLatLng(
              double.parse(pickLatLon["latitude"].toString()),
              double.parse(pickLatLon["longitude"].toString()),
            )
          ];
        }

        print(
            "++++++++++++++++latitude+++++++++++++++++++++ ${pickLatLon["latitude"]}");
        print(
            "++++++++++++++longitude++++++++++++++ ${pickLatLon["longitude"]}");
        mapLocationUpdateController.startLiveTracking();

        // _addMarker11(LatLng(double.parse(movingLat.toString()), double.parse(movingLong.toString())), "origin", BitmapDescriptor.defaultMarker);

        for (int a = 0;
            a < mapLocationUpdateController.dropOffPoints.length;
            a++) {
          mapLocationUpdateController.addMarker3("destination");
        }

        mapLocationUpdateController.addMarker2(
            LatLng(
              double.parse(pickLatLon["latitude"].toString()),
              double.parse(pickLatLon["longitude"].toString()),
            ),
            'destination');

        setState(() {});
      } else if (mapData["request_data"]["status"] == "5" ||
          mapData["request_data"]["status"] == "6") {
        List<dynamic> dropOffPointsDynamic =
            mapData["request_data"]["drop_latlon"];
        print("------List------------- $dropOffPointsDynamic");

        mapLocationUpdateController.dropOffPoints =
            dropOffPointsDynamic.map((item) {
          return PointLatLng(
            double.parse(item["latitude"].toString()),
            double.parse(item["longitude"].toString()),
          );
        }).toList();

        print(
            "++++++++++++++++latitude+++++++++++++++++++++ ${mapData["request_data"]["pick_latlon"]["latitude"]}");
        print(
            "++++++++++++++longitude++++++++++++++ ${mapData["request_data"]["pick_latlon"]["longitude"]}");
        mapLocationUpdateController.startLiveTracking();
        // mapLocationUpdateController.addMarkercurrent(LatLng(double.parse(mapData["request_data"]["pick_latlon"]["latitude"].toString()), double.parse(mapData["request_data"]["pick_latlon"]["longitude"].toString()),),"origin",BitmapDescriptor.defaultMarker);

        for (int a = 0;
            a < mapLocationUpdateController.dropOffPoints.length;
            a++) {
          mapLocationUpdateController.addMarker3("destination");
        }

        // mapLocationUpdateController.addMarker2(LatLng(double.parse(pickLatLon["latitude"].toString()), double.parse(pickLatLon["longitude"].toString()),), 'destination');

        mapLocationUpdateController.getDirections11(
          lat1: PointLatLng(
              double.parse(mapData["request_data"]["drop_latlon"]["latitude"]
                  .toString()),
              double.parse(mapData["request_data"]["drop_latlon"]["longitude"]
                  .toString())),
          dropOffPoints: mapLocationUpdateController.dropOffPoints,
        );

        setState(() {});
      }
    });
    print("----------requestId------------ ${widget.requestId}");
    print("----------time------------ ${widget.time}");

    countdownStart = (int.parse(widget.time.toString()) * 60);
    remainingTime = homeStatus == 1 ? 0 : countdownStart;
    remainingTime2 = int.parse(widget.time.toString());

    print("************ $remainingTime2");

    if (widget.timeStatus == "0") {
      startTimerAdd1();
      print("PRATIK_1");
    } else if (homeStatus == 0) {
      startTimer();
      print("PRATIK_2");
    } else {
      startTimer1();
      print("PRATIK_3");
    }

    // homeStatus == 0
    //     ? startTimer()
    //     : startTimer1();

    // widget.timeStatus == "1" ? startTimerAdd() : const SizedBox();
  }

  late int remainingTime2;
  PolylinePoints polylinePoints11 = PolylinePoints();

  _connectSocket() {
    socket.off('Vehicle_Time_Request${getData.read("UserLogin")['id']}');
    socket.off(
        'Vehicle_Ride_Cancel${getData.read("UserLogin")["id"].toString()}');

    socket.onConnect((data) => print('Connection established'));
    socket.onConnectError((data) => print('Connect Error: $data'));
    socket.onDisconnect((data) => print('Socket.IO server disconnected'));

    socket
        .on("Vehicle_Ride_Cancel${getData.read("UserLogin")["id"].toString()}",
            (status) {
      print("++++++status++++++++++++++++ ${status}");
      if (status["driverid"]
          .toString()
          .contains(getData.read("UserLogin")["id"].toString())) {
        currentIndexBottom = 0;
        // setState(() {
        //
        // });
        Get.offAll(const BottomBarScreen());
      } else {
        print("UID Not Found");
      }
    });
    socket.on("Vehicle_Time_Request${getData.read("UserLogin")['id']}", (data) {
      bottomSheetTime(requestID: widget.requestId.toString()).then(
        (value) {
          // setState(() {
          //
          // });
        },
      );
    });
  }

  late GoogleMapController mapController11;

  void _onMapCreated11(GoogleMapController controller) async {
    mapController11 = controller;
  }

  Future<Uint8List> getImages11(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // List<PointLatLng>  dropOffPoints = [];

  @override
  void dispose() {
    timer?.cancel();
    // socket.off('Vehicle_Time_Request');
    socket.off('Vehicle_Time_Request${getData.read("UserLogin")['id']}');
    socket.off(
        'Vehicle_Ride_Cancel${getData.read("UserLogin")["id"].toString()}');
    super.dispose();
  }

  RequestDetailController requestDetailController =
      Get.put(RequestDetailController());
  IAmHereController iAmHereController = Get.put(IAmHereController());
  OtpRideController otpRideController = Get.put(OtpRideController());
  final DraggableScrollableController sheetController =
      DraggableScrollableController();
  MapLocationUpdateController mapLocationUpdateController =
      Get.put(MapLocationUpdateController());

  bool isLoading = false;
  num? iAmHereTime;

  Future<void> _makingPhoneCall({required String number}) async {
    await Permission.phone.request();
    var status = await Permission.phone.status;

    if (!status.isGranted) {
      status = await Permission.phone.request();
    }

    if (status.isGranted) {
      var url = Uri.parse('tel:$number');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } else if (status.isPermanentlyDenied) {
      snackBar(context: context, text: "Please allow calls Permission");
      await openAppSettings();
    } else {
      snackBar(context: context, text: "Please allow calls Permission");
      await openAppSettings();
    }
  }

  List timeData = [
    "5",
    "10",
    "15",
    "20",
  ];

  TimeController timeController = Get.put(TimeController());
  CheckVehicleRequestController checkVehicleRequestController =
      Get.put(CheckVehicleRequestController());
  RideStartController rideStartController = Get.put(RideStartController());
  RideCancelController rideCancelController = Get.put(RideCancelController());
  CancelRequestController cancelRequestController =
      Get.put(CancelRequestController());
  CancelRequestReasonController cancelRequestReasonController =
      Get.put(CancelRequestReasonController());
  NotificationController notificationController =
      Get.put(NotificationController());

  final Completer<GoogleMapController> _controller = Completer();

  void launchGoogleMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: notifier.background,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: notifier.containerColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GetBuilder<RequestDetailController>(builder: (context) {
          return requestDetailController.isLoading
              ? requestDetailController
                              .requestDetailModel!.requestData.status ==
                          "1" ||
                      requestDetailController.requestDetailModel!.requestData.status ==
                          "2" ||
                      requestDetailController.requestDetailModel!.requestData.status ==
                          "3" ||
                      requestDetailController.requestDetailModel!.requestData.status ==
                          "5" ||
                      requestDetailController
                              .requestDetailModel!.requestData.status ==
                          "6" ||
                      requestDetailController
                              .requestDetailModel!.requestData.status ==
                          "7"
                  ? GestureDetector(
                      onTap: () {
                        checkVehicleRequestController
                            .checkVehicleApi(
                                uid: getData.read("UserLogin")["id"].toString())
                            .then((value) {
                          if (requestDetailController.requestDetailModel!.requestData.status == "1" ||
                              requestDetailController
                                      .requestDetailModel!.requestData.status ==
                                  "2" ||
                              requestDetailController
                                      .requestDetailModel!.requestData.status ==
                                  "3" ||
                              requestDetailController
                                      .requestDetailModel!.requestData.status ==
                                  "5" ||
                              requestDetailController
                                      .requestDetailModel!.requestData.status ==
                                  "6" ||
                              requestDetailController
                                      .requestDetailModel!.requestData.status ==
                                  "7") {
                            currentIndexBottom = 0;
                            homeStatus = 1;
                            setState(() {});
                            print(
                                '************homeStatus_1--------------- $homeStatus');
                            Get.offAll(const BottomBarScreen());
                          }
                        });
                      },
                      child: Icon(Icons.arrow_back,
                          size: 20, color: notifier.textColor))
                  : const SizedBox()
              : const SizedBox();
        }),
        title: GetBuilder<RequestDetailController>(
            builder: (requestDetailController) {
          return requestDetailController.isLoading
              ? requestDetailController
                          .requestDetailModel!.requestData.status ==
                      "1"
                  ? Row(children: [
                      InkWell(
                        onTap: () {
                          requestCancel();
                        },
                        child: Text(
                          "Cancel".tr,
                          style: TextStyle(
                            color: notifier.textColor,
                            fontSize: 18,
                            letterSpacing: 0.5,
                            fontFamily: FontFamily.sofiaProBold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          bottomSheetTime(
                              requestID: widget.requestId.toString());
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: appColor.withOpacity(0.12),
                          ),
                          child: Icon(Icons.timer_rounded,
                              size: 18.5, color: appColor),
                        ),
                      ),
                    ])
                  : const SizedBox()
              : const SizedBox();
        }),
        actions: [
          GestureDetector(
            onTap: () {
              notification();
            },
            child: Container(
              alignment: Alignment.center,
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appColor.withOpacity(0.12),
              ),
              child: Icon(Icons.notifications, size: 18.5, color: appColor),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: GetBuilder<RequestDetailController>(
          builder: (requestDetailController) {
        return requestDetailController.isLoading
            ? WillPopScope(
                onWillPop: () async {
                  bool shouldPop = true;
                  await checkVehicleRequestController
                      .checkVehicleApi(
                          uid: getData.read("UserLogin")["id"].toString())
                      .then((value) {
                    if (requestDetailController.requestDetailModel!.requestData.status == "2" ||
                        requestDetailController
                                .requestDetailModel!.requestData.status ==
                            "3" ||
                        requestDetailController
                                .requestDetailModel!.requestData.status ==
                            "5" ||
                        requestDetailController
                                .requestDetailModel!.requestData.status ==
                            "6" ||
                        requestDetailController
                                .requestDetailModel!.requestData.status ==
                            "7") {
                      currentIndexBottom = 0;
                      homeStatus = 1;
                      setState(() {});
                      print(
                          '************homeStatus_1--------------- $homeStatus');
                      Get.offAll(const BottomBarScreen());
                      shouldPop = false;
                    }
                  });
                  return shouldPop;
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(movingLat ?? lat, movingLong ?? long),
                        zoom: 16,
                      ),
                      myLocationEnabled: false,
                      tiltGesturesEnabled: true,
                      compassEnabled: true,
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        controller.setMapStyle(themeForMap);
                        _controller.complete(controller);
                      },
                      // onMapCreated: _onMapCreated11,
                      markers: Set<Marker>.of(
                          mapLocationUpdateController.markers11.values),
                      polylines: Set<Polyline>.of(
                          mapLocationUpdateController.polylines11.values),
                    ),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: notifier.containerColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            requestDetailController.requestDetailModel!
                                        .requestData.status ==
                                    "2"
                                ? "Enter OTP"
                                : requestDetailController.requestDetailModel!
                                                .requestData.status ==
                                            "3" ||
                                        requestDetailController
                                                .requestDetailModel!
                                                .requestData
                                                .status ==
                                            "6"
                                    ? "Start the ride"
                                    : requestDetailController
                                                .requestDetailModel!
                                                .requestData
                                                .status ==
                                            "5"
                                        ? "End the ride"
                                        : "Drive to pickup",
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 16,
                              letterSpacing: 0.5,
                              fontFamily: FontFamily.sofiaProBold,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          "Please don't be late",
                          style: TextStyle(
                            color: notifier.textColor,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            fontFamily: FontFamily.sofiaProRegular,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              homeStatus == 0
                                  ? formatTime(remainingTime)
                                  : formatTime2(remainingTime2),
                              style: TextStyle(
                                color: appColor,
                                fontSize: 25,
                                letterSpacing: 0.5,
                                fontFamily: FontFamily.sofiaProBold,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: Get.height - 550,
                      // top: -50,
                      left: 10,
                      child: GestureDetector(
                        onTap: () async {
                          // List<LatLng> locations = requestDetailController.requestDetailModel!.requestData.dropLatlon
                          //     .map((latlon) => LatLng(double.parse(latlon.latitude), double.parse(latlon.longitude)))
                          //     .toList();
                          //
                          //
                          // String waypoints = locations.skip(1).map((location) => '${location.latitude},${location.longitude}').join('|');
                          //
                          // await launchUrl(Uri.parse(
                          //     'google.navigation:q=${locations[0].latitude},${locations[0].longitude}&waypoints=$waypoints&key=${Config.mapKey}'
                          // ));
                          await launchUrl(Uri.parse(
                              'google.navigation:q=${double.parse(requestDetailController.requestDetailModel!.requestData.dropLatlon[0].latitude)}, ${double.parse(requestDetailController.requestDetailModel!.requestData.dropLatlon[0].longitude)}&key="${Config.mapKey}"'));
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: blackColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  height: 22,
                                  child: Image.asset(
                                    "assets/image/location-arrow.png",
                                    color: whiteColor,
                                  )),
                              const SizedBox(width: 5),
                              Text(
                                "Navigate",
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 15,
                                  letterSpacing: 0.5,
                                  fontFamily: FontFamily.sofiaProBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    DraggableScrollableSheet(
                      controller: sheetController,
                      builder: (BuildContext context, scrollController) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 5, right: 8),
                              decoration: BoxDecoration(
                                color: notifier.containerColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              child: CustomScrollView(
                                controller: scrollController,
                                slivers: [
                                  SliverList.list(
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
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
                                                      requestDetailController
                                                          .requestDetailModel!
                                                          .requestData
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
                                                  Text(
                                                    requestDetailController
                                                        .requestDetailModel!
                                                        .requestData
                                                        .name,
                                                    style: TextStyle(
                                                      color: notifier.textColor,
                                                      fontSize: 16,
                                                      fontFamily: FontFamily
                                                          .sofiaProRegular,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                              color: appColor),
                                                        ),
                                                        const SizedBox(
                                                            width: 6),
                                                        Flexible(
                                                          child: Text(
                                                            "${requestDetailController.requestDetailModel!.requestData.pickAdd.title} ${requestDetailController.requestDetailModel!.requestData.pickAdd.subtitle}",
                                                            style: TextStyle(
                                                              color: notifier
                                                                  .textColor,
                                                              fontSize: 13,
                                                              letterSpacing:
                                                                  0.5,
                                                              fontFamily: FontFamily
                                                                  .sofiaProBold,
                                                            ),
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
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
                                                      padding: EdgeInsets.zero,
                                                      itemCount:
                                                          requestDetailController
                                                              .requestDetailModel!
                                                              .requestData
                                                              .dropAdd
                                                              .length,
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const SizedBox(
                                                                  height: 14),
                                                      itemBuilder:
                                                          (context, index) {
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
                                                                        "assets/image/loaction_circle.svg")),
                                                            const SizedBox(
                                                                width: 6),
                                                            Flexible(
                                                              child: Text(
                                                                "${requestDetailController.requestDetailModel!.requestData.dropAdd[index].title} ${requestDetailController.requestDetailModel!.requestData.dropAdd[index].subtitle}",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      greyText,
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
                                                            width: 25),
                                                        Text(
                                                          "${getData.read("Currency")}${double.parse(requestDetailController.requestDetailModel!.requestData.price.toString())}",
                                                          style: TextStyle(
                                                            color: notifier
                                                                .textColor,
                                                            fontSize: 20,
                                                            fontFamily: FontFamily
                                                                .sofiaProBold,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const Spacer(),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _makingPhoneCall(
                                                                  number:
                                                                      "${requestDetailController.requestDetailModel!.requestData.countryCode}${requestDetailController.requestDetailModel!.requestData.phone}");
                                                            });
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50,
                                                            width: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: appColor
                                                                  .withOpacity(
                                                                      0.12),
                                                            ),
                                                            child: Icon(
                                                                Icons.call,
                                                                size: 23,
                                                                color:
                                                                    appColor),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Get.to(ChatScreen(
                                                              customer: requestDetailController
                                                                  .requestDetailModel!
                                                                  .requestData
                                                                  .cId
                                                                  .toString(),
                                                            ));
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50,
                                                            width: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: appColor
                                                                  .withOpacity(
                                                                      0.12),
                                                            ),
                                                            child: Icon(
                                                                CupertinoIcons
                                                                    .chat_bubble_2_fill,
                                                                size: 23,
                                                                color:
                                                                    appColor),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          requestDetailController
                                                      .requestDetailModel!
                                                      .requestData
                                                      .status ==
                                                  "1"
                                              ? iAmHereController.isCircle
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                              color: appColor),
                                                    )
                                                  : button(
                                                      text: "I'm here",
                                                      color: appColor,
                                                      onPress: () {
                                                        setState(() {
                                                          iAmHereController
                                                              .isCircle = true;
                                                        });
                                                        homeStatus = 0;
                                                        mapLocationUpdateController
                                                            .dropOffPoints = [];
                                                        mapLocationUpdateController
                                                            .markers11 = {};
                                                        iAmHereController
                                                            .iAmHereApi(
                                                                context:
                                                                    context,
                                                                requestID: widget
                                                                    .requestId
                                                                    .toString())
                                                            .then(
                                                          (value) {
                                                            Map<String, dynamic>
                                                                decodedValue =
                                                                json.decode(
                                                                    value);

                                                            if (decodedValue[
                                                                    "Result"] ==
                                                                true) {
                                                              iAmHereTime =
                                                                  decodedValue[
                                                                      "driver_wait_time"];
                                                              countdownStart =
                                                                  (int.parse(iAmHereTime
                                                                          .toString()) *
                                                                      60);
                                                              remainingTime =
                                                                  countdownStart; // Initialize remainingTime
                                                              startTimer();
                                                              print(
                                                                  "++++++++++iAmHereTime++++++++++++++++ ${iAmHereTime}");
                                                              socket.emit(
                                                                  'Vehicle_D_IAmHere',
                                                                  {
                                                                    'uid': getData
                                                                        .read("UserLogin")[
                                                                            "id"]
                                                                        .toString(),
                                                                    'c_id': requestDetailController
                                                                        .requestDetailModel!
                                                                        .requestData
                                                                        .cId
                                                                        .toString(),
                                                                    'request_id': widget
                                                                        .requestId
                                                                        .toString(),
                                                                    'pickuptime':
                                                                        decodedValue[
                                                                            "driver_wait_time"],
                                                                  });
                                                              requestDetailController
                                                                  .requestDetailApi(
                                                                      requestId:
                                                                          widget
                                                                              .requestId)
                                                                  .then(
                                                                      (value) {
                                                                Map<String,
                                                                        dynamic>
                                                                    mapData =
                                                                    json.decode(
                                                                        value);
                                                                print(
                                                                    "++++++++++++++++ ${mapData}");

                                                                List<dynamic>
                                                                    dropOffPointsDynamic =
                                                                    mapData["request_data"]
                                                                        [
                                                                        "drop_latlon"];
                                                                print(
                                                                    "------List------------- $dropOffPointsDynamic");

                                                                mapLocationUpdateController
                                                                        .dropOffPoints =
                                                                    dropOffPointsDynamic
                                                                        .map(
                                                                            (item) {
                                                                  return PointLatLng(
                                                                    double.parse(
                                                                        item["latitude"]
                                                                            .toString()),
                                                                    double.parse(
                                                                        item["longitude"]
                                                                            .toString()),
                                                                  );
                                                                }).toList();

                                                                print(
                                                                    "++++++++++++++++latitude+++++++++++++++++++++ ${mapData["request_data"]["pick_latlon"]["latitude"]}");
                                                                print(
                                                                    "++++++++++++++longitude++++++++++++++ ${mapData["request_data"]["pick_latlon"]["longitude"]}");
                                                                mapLocationUpdateController
                                                                    .startLiveTracking();
                                                                // mapLocationUpdateController.addMarkercurrent(LatLng(double.parse(mapData["request_data"]["pick_latlon"]["latitude"].toString()), double.parse(mapData["request_data"]["pick_latlon"]["longitude"].toString()),),"origin",BitmapDescriptor.defaultMarker);

                                                                for (int a = 0;
                                                                    a <
                                                                        mapLocationUpdateController
                                                                            .dropOffPoints
                                                                            .length;
                                                                    a++) {
                                                                  mapLocationUpdateController
                                                                      .addMarker3(
                                                                          "destination");
                                                                }

                                                                // mapLocationUpdateController.addMarker2(LatLng(double.parse(pickLatLon["latitude"].toString()), double.parse(pickLatLon["longitude"].toString()),), 'destination');

                                                                mapLocationUpdateController
                                                                    .getDirections11(
                                                                  lat1: PointLatLng(
                                                                      double.parse(mapData["request_data"]["drop_latlon"]
                                                                              [
                                                                              "latitude"]
                                                                          .toString()),
                                                                      double.parse(mapData["request_data"]["drop_latlon"]
                                                                              [
                                                                              "longitude"]
                                                                          .toString())),
                                                                  dropOffPoints:
                                                                      mapLocationUpdateController
                                                                          .dropOffPoints,
                                                                );

                                                                setState(() {});
                                                              });
                                                              setState(() {
                                                                iAmHereController
                                                                        .isCircle =
                                                                    false;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                iAmHereController
                                                                        .isCircle =
                                                                    false;
                                                              });
                                                              snackBar(
                                                                  context:
                                                                      context,
                                                                  text:
                                                                      "Something Went Wrong");
                                                            }
                                                          },
                                                        );
                                                      },
                                                    )
                                              : requestDetailController
                                                          .requestDetailModel!
                                                          .requestData
                                                          .status ==
                                                      "2"
                                                  ? button(
                                                      text: "Enter OTP",
                                                      color: appColor,
                                                      onPress: () {
                                                        setState(() {
                                                          otpBottomSheet();
                                                        });
                                                      })
                                                  : requestDetailController
                                                                  .requestDetailModel!
                                                                  .requestData
                                                                  .status ==
                                                              "3" ||
                                                          requestDetailController
                                                                  .requestDetailModel!
                                                                  .requestData
                                                                  .status ==
                                                              "6"
                                                      ? rideStartController
                                                              .isCircle
                                                          ? Center(
                                                              child: CircularProgressIndicator(
                                                                  color:
                                                                      appColor))
                                                          : Center(
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                child:
                                                                    ActionSlider
                                                                        .standard(
                                                                  sliderBehavior:
                                                                      SliderBehavior
                                                                          .stretch,
                                                                  rolling: true,
                                                                  width: double
                                                                      .infinity,
                                                                  height: 60,
                                                                  boxShadow: const [
                                                                    BoxShadow(),
                                                                  ],
                                                                  backgroundColor:
                                                                      appColor,
                                                                  toggleColor:
                                                                      Colors
                                                                          .white,
                                                                  iconAlignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  loadingIcon:
                                                                      Center(
                                                                          child:
                                                                              SizedBox(
                                                                    height: 35,
                                                                    width: 35,
                                                                    child: CircularProgressIndicator(
                                                                        color:
                                                                            appColor),
                                                                  )),
                                                                  successIcon:
                                                                      Center(
                                                                    child: SizedBox(
                                                                        width: 35,
                                                                        child: Center(
                                                                            child: Icon(
                                                                          Icons
                                                                              .check_rounded,
                                                                          color: Colors
                                                                              .green
                                                                              .shade500,
                                                                          size:
                                                                              30,
                                                                        ))),
                                                                  ),
                                                                  icon: Center(
                                                                    child: SizedBox(
                                                                        width: 35,
                                                                        child: Center(
                                                                            child: Icon(
                                                                          Icons
                                                                              .refresh_rounded,
                                                                          color:
                                                                              appColor,
                                                                          size:
                                                                              30,
                                                                        ))),
                                                                  ),
                                                                  action:
                                                                      (controller) async {
                                                                    controller
                                                                        .loading();
                                                                    mapLocationUpdateController
                                                                        .dropOffPoints = [];
                                                                    mapLocationUpdateController
                                                                        .markers11 = {};
                                                                    rideStartController
                                                                        .rideStartApi(
                                                                            context:
                                                                                context,
                                                                            requestId:
                                                                                widget.requestId.toString())
                                                                        .then(
                                                                      (value) {
                                                                        Map<String,
                                                                                dynamic>
                                                                            decodedValue =
                                                                            json.decode(value);
                                                                        if (decodedValue["Result"] ==
                                                                            true) {
                                                                          socket.emit(
                                                                              'Vehicle_Ride_Start_End',
                                                                              {
                                                                                'uid': getData.read("UserLogin")["id"].toString(),
                                                                                'c_id': requestDetailController.requestDetailModel!.requestData.cId.toString(),
                                                                                'request_id': widget.requestId.toString(),
                                                                              });
                                                                          remainingTime =
                                                                              0;
                                                                          timer
                                                                              ?.cancel();
                                                                          startTimerAdd();
                                                                          // requestDetailController.requestDetailApi(context: context, requestId: widget.requestId.toString());
                                                                          setState(
                                                                              () {});
                                                                          requestDetailController
                                                                              .requestDetailApi(requestId: widget.requestId)
                                                                              .then((value) async {
                                                                            Map<String, dynamic>
                                                                                mapData =
                                                                                json.decode(value);
                                                                            print("++++++++++++++++ ${mapData}");
                                                                            // await mapLocationUpdateController.removeMarker('origin');

                                                                            List<dynamic>
                                                                                dropOffPointsDynamic =
                                                                                mapData["request_data"]["drop_latlon"];
                                                                            print("------List------------- $dropOffPointsDynamic");

                                                                            mapLocationUpdateController.dropOffPoints =
                                                                                dropOffPointsDynamic.map((item) {
                                                                              return PointLatLng(
                                                                                double.parse(item["latitude"].toString()),
                                                                                double.parse(item["longitude"].toString()),
                                                                              );
                                                                            }).toList();

                                                                            print("++++++++++++++++latitude+++++++++++++++++++++ ${mapData["request_data"]["pick_latlon"]["latitude"]}");
                                                                            print("++++++++++++++longitude++++++++++++++ ${mapData["request_data"]["pick_latlon"]["longitude"]}");
                                                                            mapLocationUpdateController.startLiveTracking();
                                                                            // mapLocationUpdateController.addMarkercurrent(LatLng(double.parse(mapData["request_data"]["pick_latlon"]["latitude"].toString()), double.parse(mapData["request_data"]["pick_latlon"]["longitude"].toString()),),"origin",BitmapDescriptor.defaultMarker);

                                                                            for (int a = 0;
                                                                                a < mapLocationUpdateController.dropOffPoints.length;
                                                                                a++) {
                                                                              mapLocationUpdateController.addMarker3("destination");
                                                                            }

                                                                            // mapLocationUpdateController.addMarker2(LatLng(double.parse(pickLatLon["latitude"].toString()), double.parse(pickLatLon["longitude"].toString()),), 'destination');

                                                                            mapLocationUpdateController.getDirections11(
                                                                              lat1: PointLatLng(double.parse(mapData["request_data"]["drop_latlon"]["latitude"].toString()), double.parse(mapData["request_data"]["drop_latlon"]["longitude"].toString())),
                                                                              dropOffPoints: mapLocationUpdateController.dropOffPoints,
                                                                            );

                                                                            setState(() {
                                                                              rideStartController.isCircle = false;
                                                                            });
                                                                          });
                                                                        } else {
                                                                          snackBar(
                                                                              context: context,
                                                                              text: "Something Went Wrong");
                                                                          setState(
                                                                              () {
                                                                            rideStartController.isCircle =
                                                                                false;
                                                                          });
                                                                        }
                                                                      },
                                                                    );
                                                                    await Future.delayed(const Duration(
                                                                        seconds:
                                                                            3));
                                                                    controller
                                                                        .success();
                                                                    await Future.delayed(const Duration(
                                                                        seconds:
                                                                            1));
                                                                    controller
                                                                        .reset();
                                                                  },
                                                                  child: Text(
                                                                    'Swipe To Start Ride',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .sofiaProBold,
                                                                      color:
                                                                          whiteColor,
                                                                      letterSpacing:
                                                                          0.4,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                      // button(text: "Start the ride", color: Colors.green.shade500,
                                                      //     onPress: (){
                                                      //       setState(() {
                                                      //         rideStartController.isCircle = true;
                                                      //       });
                                                      //       mapLocationUpdateController.dropOffPoints = [];
                                                      //       mapLocationUpdateController.markers11 = {};
                                                      //       rideStartController.rideStartApi(context: context, requestId: widget.requestId.toString()).then((value) {
                                                      //         Map<String, dynamic> decodedValue = json.decode(value);
                                                      //         if(decodedValue["Result"] == true){
                                                      //           socket.emit('Vehicle_Ride_Start_End',{
                                                      //             'uid': getData.read("UserLogin")["id"].toString(),
                                                      //             'c_id': requestDetailController.requestDetailModel!.requestData.cId.toString(),
                                                      //             'request_id': widget.requestId.toString(),
                                                      //           });
                                                      //           remainingTime = 0;
                                                      //           timer?.cancel();
                                                      //           startTimerAdd();
                                                      //           // requestDetailController.requestDetailApi(context: context, requestId: widget.requestId.toString());
                                                      //           setState(() { });
                                                      //           requestDetailController.requestDetailApi(requestId: widget.requestId).then((value) async{
                                                      //             Map<String, dynamic> mapData = json.decode(value);
                                                      //             print("++++++++++++++++ ${mapData}");
                                                      //             // await mapLocationUpdateController.removeMarker('origin');
                                                      //
                                                      //             List<dynamic> dropOffPointsDynamic = mapData["request_data"]["drop_latlon"];
                                                      //             print("------List------------- $dropOffPointsDynamic");
                                                      //
                                                      //             mapLocationUpdateController.dropOffPoints = dropOffPointsDynamic.map((item) {
                                                      //               return PointLatLng(
                                                      //                 double.parse(item["latitude"].toString()),
                                                      //                 double.parse(item["longitude"].toString()),
                                                      //               );
                                                      //             }).toList();
                                                      //
                                                      //             print("++++++++++++++++latitude+++++++++++++++++++++ ${mapData["request_data"]["pick_latlon"]["latitude"]}");
                                                      //             print("++++++++++++++longitude++++++++++++++ ${mapData["request_data"]["pick_latlon"]["longitude"]}");
                                                      //             mapLocationUpdateController.startLiveTracking();
                                                      //             // mapLocationUpdateController.addMarkercurrent(LatLng(double.parse(mapData["request_data"]["pick_latlon"]["latitude"].toString()), double.parse(mapData["request_data"]["pick_latlon"]["longitude"].toString()),),"origin",BitmapDescriptor.defaultMarker);
                                                      //
                                                      //             for (int a = 0; a < mapLocationUpdateController.dropOffPoints.length; a++) {
                                                      //               mapLocationUpdateController.addMarker3("destination");
                                                      //             }
                                                      //
                                                      //             // mapLocationUpdateController.addMarker2(LatLng(double.parse(pickLatLon["latitude"].toString()), double.parse(pickLatLon["longitude"].toString()),), 'destination');
                                                      //
                                                      //             mapLocationUpdateController.getDirections11(lat1: PointLatLng(double.parse(mapData["request_data"]["drop_latlon"]["latitude"].toString()), double.parse(mapData["request_data"]["drop_latlon"]["longitude"].toString())), dropOffPoints: mapLocationUpdateController.dropOffPoints,);
                                                      //
                                                      //             setState(() {
                                                      //               rideStartController.isCircle = false;
                                                      //             });
                                                      //           });
                                                      //         }else{
                                                      //           snackBar(context: context, text: "Something Went Wrong");
                                                      //           setState(() {
                                                      //             rideStartController.isCircle = false;
                                                      //           });
                                                      //         }
                                                      //       },);
                                                      //     }
                                                      // )
                                                      : requestDetailController
                                                                  .requestDetailModel!
                                                                  .requestData
                                                                  .status ==
                                                              "5"
                                                          ? rideCancelController
                                                                  .isCircle
                                                              ? const Center(
                                                                  child: CircularProgressIndicator(
                                                                      color: Colors
                                                                          .pink),
                                                                )
                                                              : Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    child: ActionSlider
                                                                        .standard(
                                                                      sliderBehavior:
                                                                          SliderBehavior
                                                                              .stretch,
                                                                      rolling:
                                                                          false,
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          60,
                                                                      boxShadow: const [
                                                                        BoxShadow(),
                                                                      ],
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      toggleColor:
                                                                          Colors
                                                                              .white,
                                                                      loadingIcon:
                                                                          const Center(
                                                                              child: SizedBox(
                                                                        height:
                                                                            35,
                                                                        width:
                                                                            35,
                                                                        child: CircularProgressIndicator(
                                                                            color:
                                                                                Colors.red),
                                                                      )),
                                                                      successIcon:
                                                                          const Center(
                                                                        child: SizedBox(
                                                                            width: 35,
                                                                            child: Center(
                                                                                child: Icon(
                                                                              Icons.check_rounded,
                                                                              color: Colors.red,
                                                                              size: 30,
                                                                            ))),
                                                                      ),
                                                                      icon:
                                                                          const Center(
                                                                        child: SizedBox(
                                                                            width: 35,
                                                                            child: Center(
                                                                                child: Icon(
                                                                              Icons.directions_bike,
                                                                              color: Colors.red,
                                                                              size: 30,
                                                                            ))),
                                                                      ),
                                                                      action:
                                                                          (controller) async {
                                                                        controller
                                                                            .loading(); //starts loading animation
                                                                        rideCancelController
                                                                            .rideEndApi(
                                                                                context: context,
                                                                                requestId: widget.requestId.toString())
                                                                            .then(
                                                                          (value) {
                                                                            Map<String, dynamic>
                                                                                decodedValue =
                                                                                json.decode(value);
                                                                            if (decodedValue["Result"] ==
                                                                                true) {
                                                                              timer?.cancel();
                                                                              socket.emit('Vehicle_Ride_Start_End', {
                                                                                'uid': getData.read("UserLogin")["id"].toString(),
                                                                                'c_id': requestDetailController.requestDetailModel!.requestData.cId.toString(),
                                                                                'request_id': widget.requestId.toString(),
                                                                              });
                                                                              buttonStatus = 0;
                                                                              requestDetailController.requestDetailApi(requestId: widget.requestId.toString()).then(
                                                                                (value) {
                                                                                  requestDetailController.requestDetailModel!.requestData.status == "7"
                                                                                      ? Get.offAll(RideCompleteScreen(
                                                                                          requestId: widget.requestId.toString(),
                                                                                          cID: requestDetailController.requestDetailModel!.requestData.cId.toString(),
                                                                                          status: requestDetailController.requestDetailModel!.requestData.status.toString(),
                                                                                        ))
                                                                                      : const SizedBox();
                                                                                },
                                                                              );
                                                                              setState(() {
                                                                                rideCancelController.isCircle = false;
                                                                              });
                                                                            } else {
                                                                              snackBar(context: context, text: "Something Went Wrong");
                                                                              setState(() {
                                                                                rideCancelController.isCircle = false;
                                                                              });
                                                                            }
                                                                          },
                                                                        );
                                                                        await Future.delayed(const Duration(
                                                                            seconds:
                                                                                3));
                                                                        controller
                                                                            .success();
                                                                        await Future.delayed(const Duration(
                                                                            seconds:
                                                                                1));
                                                                        controller
                                                                            .reset();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Swipe To End Ride',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              FontFamily.sofiaProBold,
                                                                          color:
                                                                              whiteColor,
                                                                          letterSpacing:
                                                                              0.4,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                          //     : button(text: "Finish the ride", color: Colors.red,
                                                          //     onPress: (){
                                                          //       setState(() {
                                                          //         rideCancelController.isCircle = true;
                                                          //       });
                                                          //       rideCancelController.rideEndApi(context: context, requestId: widget.requestId.toString()).then((value) {
                                                          //         Map<String, dynamic> decodedValue = json.decode(value);
                                                          //         if(decodedValue["Result"] == true){
                                                          //           timer?.cancel();
                                                          //           socket.emit('Vehicle_Ride_Start_End',{
                                                          //             'uid': getData.read("UserLogin")["id"].toString(),
                                                          //             'c_id': requestDetailController.requestDetailModel!.requestData.cId.toString(),
                                                          //             'request_id': widget.requestId.toString(),
                                                          //           });
                                                          //           buttonStatus = 0;
                                                          //           requestDetailController.requestDetailApi(requestId: widget.requestId.toString()).then((value) {
                                                          //             requestDetailController.requestDetailModel!.requestData.status == "7"
                                                          //                 ? Get.offAll(RideCompleteScreen(requestId: widget.requestId.toString(),cID: requestDetailController.requestDetailModel!.requestData.cId.toString(),status: requestDetailController.requestDetailModel!.requestData.status.toString(),)) : const SizedBox();
                                                          //           },);
                                                          //           setState(() {
                                                          //             rideCancelController.isCircle = false;
                                                          //           });
                                                          //         }else{
                                                          //           snackBar(context: context, text: "Something Went Wrong");
                                                          //           setState(() {
                                                          //             rideCancelController.isCircle = false;
                                                          //           });
                                                          //         }
                                                          //       },);
                                                          //     }
                                                          // )
                                                          : const SizedBox(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator(color: appColor));
      }),
    );
  }

  Future otpBottomSheet() {
    return Get.bottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      ignoreSafeArea: true,
      StatefulBuilder(
        builder: (context, setState) {
          return BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: Container(
              decoration: BoxDecoration(
                color: notifier.background,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "Enter OTP to Start Ride".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.sofiaProBold,
                          fontSize: 16,
                          color: appColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    textfield(
                      textInputType: TextInputType.number,
                      type: "Enter Otp",
                      controller: otpRideController.otpController,
                      labelText: "Enter 4 digit Otp",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Otp';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: otpRideController.isCircle
                          ? Center(
                              child: CircularProgressIndicator(color: appColor),
                            )
                          : button(
                              text: "Send",
                              color: appColor,
                              onPress: () {
                                setState(() {
                                  otpRideController.isCircle = true;
                                });
                                otpRideController
                                    .otpRideApi(
                                        context: context,
                                        requestId: widget.requestId.toString(),
                                        otp: otpRideController
                                            .otpController.text,
                                        time: "${timmer == 0 ? "0" : timmer}")
                                    .then(
                                  (value) {
                                    Map<String, dynamic> decodedValue =
                                        json.decode(value);
                                    if (decodedValue["Result"] == true) {
                                      timer?.cancel();
                                      homeStatus == 0
                                          ? formatTime(remainingTime)
                                          : formatTime2(remainingTime2);
                                      print(
                                          "++++++++remainingTime123+++++++++++ $remainingTime");
                                      socket.emit('Vehicle_Ride_OTP', {
                                        'uid': getData
                                            .read("UserLogin")["id"]
                                            .toString(),
                                        'c_id': requestDetailController
                                            .requestDetailModel!.requestData.cId
                                            .toString(),
                                        'request_id':
                                            widget.requestId.toString(),
                                        'status': true,
                                      });
                                      print(
                                          "++++++++timer+++++++++++ ${timer}");

                                      print(
                                          "++++++++countdownStart+++++++++++ ${countdownStart}");
                                      requestDetailController.requestDetailApi(
                                          requestId:
                                              widget.requestId.toString());
                                      Get.back();
                                      setState(() {
                                        setState(() {
                                          otpRideController.isCircle = false;
                                        });
                                      });
                                    }
                                  },
                                );
                              }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  final note = TextEditingController();

  var selectedRadioTile;

  String? rejectMsg = '';

  requestCancel() {
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: notifier.background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: Get.height * 0.02),
                    Container(
                        height: 6,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(25))),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "Select Reason".tr,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Gilroy Bold',
                          color: notifier.textColor),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "Please select the reason for cancellation:".tr,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Gilroy Medium',
                          color: notifier.textColor),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    ListView.builder(
                      itemCount: cancelRequestReasonController
                          .cancelRequestReasonModel!.rideCancelList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return InkWell(
                          onTap: () {
                            setState(() {});
                            selectedRadioTile = i;
                            rejectMsg = cancelRequestReasonController
                                .cancelRequestReasonModel!.rideCancelList[i].id
                                .toString();
                          },
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 25,
                                ),
                                Radio(
                                  activeColor: appColor,
                                  value: i,
                                  groupValue: selectedRadioTile,
                                  onChanged: (value) {
                                    setState(() {});
                                    selectedRadioTile = value;
                                    rejectMsg = cancelRequestReasonController
                                        .cancelRequestReasonModel!
                                        .rideCancelList[i]
                                        .id
                                        .toString();
                                  },
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  cancelRequestReasonController
                                      .cancelRequestReasonModel!
                                      .rideCancelList[i]
                                      .title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Gilroy Medium',
                                    color: notifier.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    rejectMsg == "Others".tr
                        ? SizedBox(
                            height: 50,
                            width: Get.width * 0.85,
                            child: TextField(
                              controller: note,
                              decoration: InputDecoration(
                                  isDense: true,
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF246BFD), width: 1),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF246BFD), width: 1),
                                  ),
                                  hintText: 'Enter reason'.tr,
                                  hintStyle: TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      fontSize: Get.size.height / 55,
                                      color: Colors.grey)),
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(height: Get.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: Get.width * 0.35,
                          height: Get.height * 0.05,
                          child: cancelButton(
                            title: "Cancel".tr,
                            bgColor: Colors.red,
                            titleColor: Colors.white,
                            ontap: () {
                              Get.back();
                            },
                          ),
                        ),
                        GetBuilder<CancelRequestController>(
                          builder: (context) {
                            return SizedBox(
                              width: Get.width * 0.35,
                              height: Get.height * 0.05,
                              child: cancelButton1(
                                title: "Confirm".tr,
                                titleColor: Colors.white,
                                ontap: () {
                                  cancelRequestController.cancelRequestApi(
                                      context: context,
                                      requestId: widget.requestId.toString(),
                                      cID: requestDetailController
                                          .requestDetailModel!.requestData.cId
                                          .toString(),
                                      cancelId: rejectMsg);
                                  socket.emit('Vehicle_Accept_Cancel', {
                                    'uid': getData
                                        .read("UserLogin")["id"]
                                        .toString(),
                                    'c_id': requestDetailController
                                        .requestDetailModel!.requestData.cId
                                        .toString(),
                                    'request_id': widget.requestId.toString(),
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.04),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  cancelButton(
      {Function()? ontap,
      String? title,
      Color? bgColor,
      titleColor,
      Gradient? gradient1}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: Get.height * 0.04,
        width: Get.width * 0.40,
        decoration: BoxDecoration(
          color: bgColor,
          gradient: gradient1,
          borderRadius: (BorderRadius.circular(18)),
        ),
        child: Center(
          child: Text(title!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  fontFamily: 'Gilroy Medium')),
        ),
      ),
    );
  }

  cancelButton1(
      {Function()? ontap,
      String? title,
      Color? bgColor,
      titleColor,
      Gradient? gradient1}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: Get.height * 0.04,
        width: Get.width * 0.40,
        decoration: BoxDecoration(
          color: appColor,
          gradient: gradient1,
          borderRadius: (BorderRadius.circular(18)),
        ),
        child: Center(
          child: Text(title!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  fontFamily: 'Gilroy Medium')),
        ),
      ),
    );
  }

  Future bottomSheetTime({required String requestID}) {
    return Get.bottomSheet(
      // isDismissible: false,
      isScrollControlled: true,
      // enableDrag: false,
      StatefulBuilder(
        builder: (context, setState) {
          return BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                color: notifier.background,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  requestDetailController
                                      .requestDetailModel!.requestData.name[0]
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 18,
                                    fontFamily: FontFamily.sofiaProBold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                requestDetailController
                                    .requestDetailModel!.requestData.name,
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 16,
                                  fontFamily: FontFamily.sofiaProRegular,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 6),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 2,
                                      child: Icon(
                                          CupertinoIcons.location_north_fill,
                                          size: 20,
                                          color: appColor),
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        "${requestDetailController.requestDetailModel!.requestData.pickAdd.title} ${requestDetailController.requestDetailModel!.requestData.pickAdd.subtitle}",
                                        style: TextStyle(
                                          color: notifier.textColor,
                                          fontSize: 13,
                                          letterSpacing: 0.5,
                                          fontFamily: FontFamily.sofiaProBold,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: requestDetailController
                                      .requestDetailModel!
                                      .requestData
                                      .dropAdd
                                      .length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 14),
                                  itemBuilder: (context, index) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: SvgPicture.asset(
                                                "assets/image/loaction_circle.svg")),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            "${requestDetailController.requestDetailModel!.requestData.dropAdd[index].title} ${requestDetailController.requestDetailModel!.requestData.dropAdd[index].subtitle}",
                                            style: TextStyle(
                                              color: greyText,
                                              fontSize: 13,
                                              letterSpacing: 0.5,
                                              height: 1.1,
                                              fontFamily:
                                                  FontFamily.sofiaProBold,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 25),
                                    Text(
                                      "${getData.read("Currency")}${double.parse(requestDetailController.requestDetailModel!.requestData.price.toString())}",
                                      style: TextStyle(
                                        color: notifier.textColor,
                                        fontSize: 20,
                                        fontFamily: FontFamily.sofiaProBold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "How soon will you arrive?",
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 20,
                          fontFamily: FontFamily.sofiaProBold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: timeData.length,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return button2(
                              text: "${timeData[index]} min.",
                              color: Colors.green.shade500,
                              onPress: () {
                                setState(() {
                                  isLoading = true;
                                  print('iOiOiOiOiO:__${isLoading}');
                                });
                                print(
                                    "+++++++++++++++++++++++ ${timeData[index]}");
                                // timeController.timeApi(context: context, requestId: requestID, cId: requestDetailController.requestDetailModel!.requestData.cId.toString(), time: timeData[index].toString(),).then((value) { Map<String, dynamic> decodedValue = json.decode(value);
                                // if(decodedValue["Result"] == true){
                                socket.emit('Vehicle_Time_update', {
                                  'uid': getData
                                      .read("UserLogin")["id"]
                                      .toString(),
                                  'request_id': requestID,
                                  'c_id': requestDetailController
                                      .requestDetailModel!.requestData.cId
                                      .toString(),
                                  'time': timeData[index].toString()
                                });
                                isLoading = false;
                                homeStatus = 0;
                                print('ELELELELELELELELE:__${isLoading}');
                                countdownStart = (int.parse(
                                        timeData[index].toString()) *
                                    60); // Initialize countdownStart with widget.time
                                remainingTime = countdownStart;
                                print(
                                    "********///////-------- ${remainingTime}");
                                startTimer();
                                setState(() {});
                                Get.close(1);

                                // }else{
                                //   snackBar(context: context, text: "Something went Wrong");
                                // }
                                // },
                                // );
                              });
                        },
                      ),
                      const SizedBox(height: 25),
                      button(
                          text: "Default Time",
                          color: appColor,
                          onPress: () {
                            Get.back();
                          }),
                    ],
                  ),
                  isLoading == true
                      ? BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: appColor,
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  int selectNotification = -1;

  Future notification() {
    selectNotification = -1;
    return Get.bottomSheet(
      // isScrollControlled: true,
      StatefulBuilder(
        builder: (context, setState) {
          return BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                color: notifier.background,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Send Notification".tr,
                    style: TextStyle(
                      fontFamily: FontFamily.sofiaProBold,
                      fontSize: 16,
                      color: notifier.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: requestDetailController
                          .requestDetailModel!.demList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return button3(
                            textColor: selectNotification == index
                                ? whiteColor
                                : notifier.textColor,
                            borderColor: selectNotification == index
                                ? appColor
                                : notifier.borderColor,
                            text: requestDetailController
                                .requestDetailModel!.demList[index].title,
                            color: selectNotification == index
                                ? appColor
                                : notifier.containerColor,
                            onPress: () {
                              setState(() {
                                selectNotification = index;
                                notificationController.notificationId =
                                    requestDetailController
                                        .requestDetailModel!.demList[index].id
                                        .toString();
                              });
                            });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  button(
                      text: "SEND".tr,
                      color: appColor,
                      onPress: () {
                        notificationController.notification(
                            context: context,
                            requestId: widget.requestId.toString());
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
