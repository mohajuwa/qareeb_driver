// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:action_slider/action_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qareeb/screen/map/map_ride_screen.dart';
import 'package:qareeb/utils/colors.dart';
import 'package:get/get.dart';
import 'package:qareeb/widget/common.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../bottom_navigation_bar.dart';
import '../../config/config.dart';
import '../../config/data_store.dart';
import '../../controller/accept_request_controller.dart';
import '../../controller/cancel_request_controller.dart';
import '../../controller/check_vehicle_request_controller.dart';
import '../../controller/request_detail_controller.dart';
import '../../controller/time_controller.dart';
import '../../controller/update_location_controller.dart';
import '../../main.dart';
import '../../utils/font_family.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import '../../widget/dark_light_mode.dart';
import '../home/home_screen.dart';
import '../home/sound_player.dart';

class MapScreen extends StatefulWidget {
  final String requestID;

  const MapScreen({super.key, required this.requestID});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final Set<Polygon> _polygon = HashSet<Polygon>();
  final Set<Marker> _markers = {};
  GoogleMapController? mapController;

  final ScrollController _scrollController = ScrollController();
  late IO.Socket socket;

  void _scrollToNextItem() {
    final double offset = _scrollController.offset + 200.0;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  late ColorNotifier notifier;
  String themeForMap = "";

  getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previousState = prefs.getBool("setIsDark");
    if (previousState == null) {
      notifier.setIsDark = false;
    } else {
      notifier.setIsDark = previousState;
    }
  }

  mapThemeStyle() {
    if (darkMode == true) {
      setState(() {
        DefaultAssetBundle.of(
          context,
        ).loadString("i_theme/dark_theme.json").then((value) {
          setState(() {
            themeForMap = value;
          });
        });
      });
    }
  }

  bool isControllerInitialized = false;

  @override
  void initState() {
    getDarkMode();
    mapThemeStyle();
    notificationSoundPlayer.stopNotificationSound();
    // Timer(const Duration(seconds: 2), () {

    // });

    socketConnect();
    print("//////requestID///////////////// ${widget.requestID}");
    // requestDetailController.requestDetailApi(requestId: widget.requestID).then((value) {
    //   Map<String, dynamic> mapData = json.decode(value);
    //   print("++++++++++++++++ ${mapData}");
    //
    //   // mapData["request_data"]["status"] == "1" ? bottomSheet(requestID: widget.requestID.toString()) : const SizedBox();
    //
    //   List<dynamic> dropOffPointsDynamic = mapData["request_data"]["drop_latlon"];
    //   // List<Map<String, String>> nameLocation = mapData["request_data"]["drop_latlon"];
    //   print("------List------------- $dropOffPointsDynamic");
    //
    //   dropOffPoints = dropOffPointsDynamic.map((item) {
    //     return PointLatLng(
    //       double.parse(item["latitude"].toString()),
    //       double.parse(item["longitude"].toString()),
    //     );
    //   }).toList();
    //
    //   print(
    //       "++++++++++++++++latitude+++++++++++++++++++++ ${mapData["request_data"]["pick_latlon"]["latitude"]}");
    //   print(
    //       "++++++++++++++longitude+++++++++++++++++++++++ ${mapData["request_data"]["pick_latlon"]["longitude"]}");
    //   _addMarker11(
    //     LatLng(
    //       double.parse(
    //           mapData["request_data"]["pick_latlon"]["latitude"].toString()),
    //       double.parse(
    //           mapData["request_data"]["pick_latlon"]["longitude"].toString()),
    //     ),
    //     "origin",
    //     BitmapDescriptor.defaultMarker,
    //     "${requestDetailController.requestDetailModel!.requestData.pickAdd.title} ${requestDetailController.requestDetailModel!.requestData.pickAdd.subtitle}"
    //
    //   );
    //
    //   for (int a = 0; a < dropOffPoints.length; a++) {
    //     _addMarker3("destination",);
    //   }
    //
    //   getDirections11(
    //     lat1: PointLatLng(
    //         double.parse(
    //             mapData["request_data"]["pick_latlon"]["latitude"].toString()),
    //         double.parse(mapData["request_data"]["pick_latlon"]["longitude"]
    //             .toString())),
    //     dropOffPoints: dropOffPoints,
    //   );
    //
    //   setState(() {});
    // });
    requestDetailController.requestDetailApi(requestId: widget.requestID).then((
      value,
    ) {
      if (value == null) {
        notificationSoundPlayer.stopNotificationSound();
        print("Error: API response is null");
        notificationSoundPlayer.stopNotificationSound();
        checkVehicleRequestController.checkVehicleApi(
          uid: getData.read("UserLogin")["id"].toString(),
        );
        currentIndexBottom = 0;
        // setState(() {
        //
        // });
        Get.offAll(const BottomBarScreen());
        return;
      }

      try {
        Map<String, dynamic> mapData = json.decode(value);
        print(
          "+++++mapDatamapDatamapDatamapDatamapDatamapDatamapData+++++++++++ ${mapData}",
        );
        notificationSoundPlayer.playNotificationSound(
          url:
              "${Config.imageUrl}${checkVehicleRequestController.checkVehicleRequestModel!.general.alertTone}",
        );

        controller = AnimationController(
          vsync: this,
          duration: Duration(
            seconds: int.parse(
              requestDetailController
                  .requestDetailModel!.requestData.rideExpireTime
                  .toString(),
            ),
          ),
        );

        colorAnimation = ColorTween(
          begin: Colors.blue,
          end: Colors.green,
        ).animate(controller);

        controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            cancelRequestController.cancelRequestApi(
              context: context,
              requestId: widget.requestID.toString(),
              cID: requestDetailController.requestDetailModel!.requestData.cId
                  .toString(),
            );
            notificationSoundPlayer.stopNotificationSound();
          }
        });

        controller.forward();

        List<dynamic> dropOffPointsDynamic =
            mapData["request_data"]["drop_latlon"];
        List<dynamic> locationList = mapData["request_data"]["drop_add"];
        print("------List------------- $dropOffPointsDynamic");

        dropOffPoints = dropOffPointsDynamic.map((item) {
          return PointLatLng(
            double.parse(item["latitude"].toString()),
            double.parse(item["longitude"].toString()),
          );
        }).toList();

        LatLng pickUpLocation = LatLng(
          double.parse(
            mapData["request_data"]["pick_latlon"]["latitude"].toString(),
          ),
          double.parse(
            mapData["request_data"]["pick_latlon"]["longitude"].toString(),
          ),
        );

        _addMarker11(
          pickUpLocation,
          "origin",
          BitmapDescriptor.defaultMarker,
          "${requestDetailController.requestDetailModel!.requestData.pickAdd.title} ${requestDetailController.requestDetailModel!.requestData.pickAdd.subtitle}",
        );

        // Prepare drop-off data for markers
        List<Map<String, String>> dropOffData = locationList.map((item) {
          return {
            "title": item["title"]?.toString() ?? "Unknown",
            "subtitle": item["subtitle"]?.toString() ?? "No Address Provided",
          };
        }).toList();

        for (int a = 0; a < dropOffPoints.length; a++) {
          _addMarker3("destination_$a", dropOffData);
        }

        getDirections11(
          lat1: PointLatLng(
            double.parse(
              mapData["request_data"]["pick_latlon"]["latitude"].toString(),
            ),
            double.parse(
              mapData["request_data"]["pick_latlon"]["longitude"].toString(),
            ),
          ),
          dropOffPoints: dropOffPoints,
        );

        setState(() {
          isControllerInitialized = true;
        });
      } catch (e) {
        print("Error processing API response: $e");
      }
    });
    super.initState();
  }

  socketConnect() async {
    socket = IO.io(Config.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    _connectSocket();
  }

  _connectSocket() {
    socket.off('vehiclerequest');
    socket.off('AcceRemoveOther');
    socket.off('RequestTimeOut');
    socket.off('removeotherdata${getData.read("UserLogin")["id"].toString()}');
    // socket.close();
    // socket.off('Vehicle_Ride_Cancel');
    // socket.off('AcceRemoveOther');
    // socket.off('TimeOut_Driver_VBidding');

    socket.onConnect((data) => print('Connection established request'));
    socket.onConnectError((data) => print('Connect Error: $data'));
    socket.onDisconnect((data) => print('Socket.IO server disconnected'));

    socket.on('vehiclerequest', (request) {
      notificationSoundPlayer.stopNotificationSound();
      print(
        "-----request2222221991838------------ ${request["requestid"].toString()}",
      );
      print("-----id2222222------------ ${request["driverid"]}");

      if (request["driverid"].toString().contains(
            getData.read("UserLogin")["id"].toString(),
          )) {
        notificationSoundPlayer.stopNotificationSound();
        currentIndexBottom = 0;
        // setState(() {
        //
        // });
        Get.offAll(const BottomBarScreen());
        // Get.back();
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
        Get.offAll(const BottomBarScreen());
      } else {
        print("UID Not Found");
      }
    });

    socket.on(
      "TimeOut_Driver_VBidding${getData.read("UserLogin")["id"].toString()}",
      (data) {
        print("++++++request123456789++++++++++++++++ ${data}");
        currentIndexBottom = 0;
        notificationSoundPlayer.stopNotificationSound();
        Get.offAll(const BottomBarScreen());
      },
    );

    socket.on('removeotherdata${getData.read("UserLogin")["id"].toString()}', (
      request,
    ) {
      print("-----request------------ ${request["requestid"].toString()}");
      print("-----id------------ ${request["driverid"]}");
      if (request["driverid"].toString().contains(
            getData.read("UserLogin")["id"].toString(),
          )) {
        currentIndexBottom = 0;
        notificationSoundPlayer.stopNotificationSound();
        Get.offAll(const BottomBarScreen());
      } else {
        print("UID Not Found");
      }
    });

    socket.on("Accept_Bidding${getData.read("UserLogin")["id"].toString()}", (
      request,
    ) {
      print("+++<><><>+++request123456789<><><><><><<>${request}");
      homeStatus = 0;
      requestDetailController
          .requestDetailApi(requestId: request["requestid"].toString())
          .then((value) {
        notificationSoundPlayer.stopNotificationSound();
        Get.to(
          MapRideScreen(
            time: requestDetailController
                .requestDetailModel!.requestData.totMinute
                .toString(),
            requestId: request["requestid"].toString(),
          ),
        );
      });
    });

    socket.on("Bidding_decline${getData.read("UserLogin")["id"].toString()}", (
      request,
    ) {
      print("+++<><><>+++request123456789<><><><><><<>${request}");
      notificationSoundPlayer.stopNotificationSound();
      Get.back();
    });

    socket.on("RequestTimeOut", (status) {
      print("--++++++-++658455554555 ${status}");
      if (status["driverid"].toString().contains(
            getData.read("UserLogin")["id"].toString(),
          )) {
        checkVehicleRequestController.checkVehicleApi(
          uid: getData.read("UserLogin")["id"].toString(),
        );
        currentIndexBottom = 0;
        notificationSoundPlayer.stopNotificationSound();
        Get.offAll(const BottomBarScreen());
      } else {
        print("UID Not Found");
      }
    });
  }

  final NotificationSoundPlayer notificationSoundPlayer =
      NotificationSoundPlayer();

  @override
  void dispose() {
    controller.dispose();
    socket.off('vehiclerequest');
    socket.off('AcceRemoveOther');
    socket.off('RequestTimeOut');
    socket.off('removeotherdata${getData.read("UserLogin")["id"].toString()}');
    // socket.close();
    notificationSoundPlayer.stopNotificationSound();
    super.dispose();
  }

  RequestDetailController requestDetailController = Get.put(
    RequestDetailController(),
  );
  AcceptRequestController acceptRequestController = Get.put(
    AcceptRequestController(),
  );
  TimeController timeController = Get.put(TimeController());
  CancelRequestController cancelRequestController = Get.put(
    CancelRequestController(),
  );
  CheckVehicleRequestController checkVehicleRequestController = Get.put(
    CheckVehicleRequestController(),
  );
  UpdateLocationController updateLocationController = Get.put(
    UpdateLocationController(),
  );

  late GoogleMapController mapController11;

  Map<MarkerId, Marker> markers11 = {};
  Map<PolylineId, Polyline> polylines11 = {};
  List<LatLng> polylineCoordinates11 = [];
  PolylinePoints polylinePoints11 = PolylinePoints();

  void _onMapCreated11(GoogleMapController controller) async {
    controller.setMapStyle(themeForMap);
    mapController11 = controller;
  }

  Future<Uint8List> getImages11(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!
        .buffer
        .asUint8List();
  }

  List<PointLatLng> dropOffPoints = [];

  List timeData = ["5", "10", "15", "20"];

  late AnimationController controller;
  late Animation<Color?> colorAnimation;

  bool isLoading = false;
  bool isLoadingAccepted = false;
  StreamSubscription<Position>? positionStreamSubscription;
  int selectBidIndex = -1;

  TextEditingController bidController = TextEditingController();

  cancelSocket({required String requestID, required String cId}) {
    // socket.emit('Vehicle_Bidding', {
    //   'uid': getData.read("UserLogin")["id"].toString(),
    //   'request_id': requestID,
    //   'c_id': cId,
    //   'price': "",
    //   'status': "2",
    // });
    // cancelRequestController.cancelRequestApi(context: context, requestId: cId, cID: cId);
    setState(() {
      checkVehicleRequestController.checkVehicleApi(
        uid: getData.read("UserLogin")["id"].toString(),
      );
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      currentIndexBottom = 0;
      notificationSoundPlayer.stopNotificationSound();
      Get.offAll(const BottomBarScreen());
    });
  }

  rejectBack() {
    setState(() {
      currentIndexBottom = 0;
      Get.offAll(const BottomBarScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    if (!isControllerInitialized) {
      return Container(
        height: Get.height,
        width: Get.width,
        color: notifier.background,
        child: Center(child: CircularProgressIndicator(color: appColor)),
      ); // Show a loading spinner
    }
    return WillPopScope(
      onWillPop: () async {
        currentIndexBottom = 0;
        setState(() {});
        return requestDetailController.requestDetailModel!.requestData.status ==
                "1"
            ? await Get.offAll(const BottomBarScreen())
            : false;
      },
      child: Scaffold(
        body: GetBuilder<RequestDetailController>(
          builder: (requestDetailController) {
            return requestDetailController.isLoading
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          width: Get.size.width,
                          decoration: BoxDecoration(color: notifier.background),
                          child: Stack(
                            children: [
                              GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    double.parse(
                                      requestDetailController
                                          .requestDetailModel!
                                          .requestData
                                          .pickLatlon
                                          .latitude
                                          .toString(),
                                    ),
                                    double.parse(
                                      requestDetailController
                                          .requestDetailModel!
                                          .requestData
                                          .pickLatlon
                                          .longitude
                                          .toString(),
                                    ),
                                  ),
                                  zoom: 16,
                                ),
                                myLocationEnabled: true,
                                tiltGesturesEnabled: true,
                                compassEnabled: true,
                                scrollGesturesEnabled: true,
                                zoomGesturesEnabled: true,
                                onMapCreated: _onMapCreated11,
                                markers: Set<Marker>.of(markers11.values),
                                polylines: Set<Polyline>.of(polylines11.values),
                              ),
                              Positioned(
                                right: 15,
                                top: 35,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      notifier.containerColor,
                                    ),
                                    elevation: const WidgetStatePropertyAll(0),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    checkVehicleRequestController
                                        .checkVehicleApi(
                                      uid: getData
                                          .read("UserLogin")["id"]
                                          .toString(),
                                    )
                                        .then((value) {
                                      currentIndexBottom = 0;
                                      notificationSoundPlayer
                                          .stopNotificationSound();
                                      Get.offAll(const BottomBarScreen());
                                      scaffoldMessengerKey.currentState
                                          ?.hideCurrentSnackBar();
                                      setState(() {});
                                    });
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.close,
                                        color: notifier.textColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Skip",
                                        style: TextStyle(
                                          color: notifier.textColor,
                                          fontSize: 16,
                                          fontFamily:
                                              FontFamily.sofiaProRegular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DraggableScrollableSheet(
                                builder:
                                    (BuildContext context, scrollController) {
                                  return Container(
                                    clipBehavior: Clip.hardEdge,
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                      left: 5,
                                      right: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: notifier.containerColor,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25),
                                      ),
                                    ),
                                    child: Stack(
                                      // alignment: Alignment.center,
                                      children: [
                                        SingleChildScrollView(
                                          controller: scrollController,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Column(
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
                                                        alignment:
                                                            Alignment.center,
                                                        height: 70,
                                                        width: 70,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: appColor,
                                                          shape:
                                                              BoxShape.circle,
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
                                                          color: notifier
                                                              .textColor,
                                                          fontSize: 16,
                                                          fontFamily: FontFamily
                                                              .sofiaProRegular,
                                                        ),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/image/rating_filled.svg",
                                                            color: Colors
                                                                .amber.shade800,
                                                          ),
                                                          Text(
                                                            "${requestDetailController.requestDetailModel!.requestData.rating}(${requestDetailController.requestDetailModel!.requestData.review})",
                                                            style: TextStyle(
                                                              color: notifier
                                                                  .textColor,
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  0.5,
                                                              fontFamily: FontFamily
                                                                  .sofiaProRegular,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
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
                                                                "${requestDetailController.requestDetailModel!.requestData.pickAdd.title} ${requestDetailController.requestDetailModel!.requestData.pickAdd.subtitle}",
                                                                style:
                                                                    TextStyle(
                                                                  color: notifier
                                                                      .textColor,
                                                                  fontSize: 13,
                                                                  letterSpacing:
                                                                      0.5,
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
                                                        ),
                                                        const SizedBox(
                                                          height: 14,
                                                        ),
                                                        ListView.separated(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          itemCount:
                                                              requestDetailController
                                                                  .requestDetailModel!
                                                                  .requestData
                                                                  .dropAdd
                                                                  .length,
                                                          separatorBuilder: (
                                                            context,
                                                            index,
                                                          ) =>
                                                              const SizedBox(
                                                            height: 14,
                                                          ),
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
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "assets/image/loaction_circle.svg",
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 6,
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                    "${requestDetailController.requestDetailModel!.requestData.dropAdd[index].title} ${requestDetailController.requestDetailModel!.requestData.dropAdd[index].subtitle}",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          greyText,
                                                                      fontSize:
                                                                          13,
                                                                      letterSpacing:
                                                                          0.5,
                                                                      height:
                                                                          1.1,
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
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizedBox(
                                                              width: 25,
                                                            ),
                                                            Text(
                                                              "${getData.read("Currency")}${double.parse(requestDetailController.requestDetailModel!.requestData.price.toString())}",
                                                              style: TextStyle(
                                                                color: notifier
                                                                    .textColor,
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .sofiaProBold,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              "${requestDetailController.requestDetailModel!.requestData.perKmPrice}${getData.read("Currency")}/Km",
                                                              style: TextStyle(
                                                                color: notifier
                                                                    .textColor,
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .sofiaProBold,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              "${requestDetailController.requestDetailModel!.requestData.totKm} Km",
                                                              style: TextStyle(
                                                                color: appColor,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .sofiaProBold,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                        // const SizedBox(height: 8),
                                                        // Row(
                                                        //   children: [
                                                        //     const SizedBox(
                                                        //         width: 25),
                                                        //     Text(
                                                        //       "Payment by card",
                                                        //       style: TextStyle(
                                                        //         color: greyText,
                                                        //         fontSize: 14,
                                                        //         fontFamily: FontFamily
                                                        //             .sofiaProRegular,
                                                        //       ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                ),
                                                child: GetBuilder<
                                                    AcceptRequestController>(
                                                  builder:
                                                      (acceptRequestController) {
                                                    return requestDetailController
                                                                    .requestDetailModel!
                                                                    .requestData
                                                                    .biddingStatus ==
                                                                "1" &&
                                                            requestDetailController
                                                                    .requestDetailModel!
                                                                    .requestData
                                                                    .biddAutoStatus ==
                                                                "0"
                                                        ? Center(
                                                            child: ActionSlider
                                                                .standard(
                                                              sliderBehavior:
                                                                  SliderBehavior
                                                                      .stretch,
                                                              rolling: false,
                                                              width: double
                                                                  .infinity,
                                                              height: 49,
                                                              backgroundBorderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                15,
                                                              ),
                                                              foregroundBorderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                10,
                                                              ),
                                                              boxShadow: const [
                                                                BoxShadow(),
                                                              ],
                                                              backgroundColor:
                                                                  Colors.green,
                                                              toggleColor:
                                                                  Colors.white,
                                                              loadingIcon:
                                                                  const Center(
                                                                child: SizedBox(
                                                                  height: 25,
                                                                  width: 25,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                              ),
                                                              successIcon:
                                                                  const Center(
                                                                child: SizedBox(
                                                                  width: 35,
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .check_rounded,
                                                                      color: Colors
                                                                          .green,
                                                                      size: 30,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              icon:
                                                                  const Center(
                                                                child: SizedBox(
                                                                  width: 35,
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .directions_bike,
                                                                      color: Colors
                                                                          .green,
                                                                      size: 25,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              action:
                                                                  (controller1) async {
                                                                controller1
                                                                    .loading(); //starts loading animation
                                                                socket.emit(
                                                                  'Vehicle_Bidding',
                                                                  {
                                                                    'uid': getData
                                                                        .read(
                                                                          "UserLogin",
                                                                        )["id"]
                                                                        .toString(),
                                                                    'request_id': requestDetailController
                                                                        .requestDetailModel!
                                                                        .requestData
                                                                        .id
                                                                        .toString(),
                                                                    'c_id': requestDetailController
                                                                        .requestDetailModel!
                                                                        .requestData
                                                                        .cId
                                                                        .toString(),
                                                                    'price':
                                                                        "${double.parse(requestDetailController.requestDetailModel!.requestData.price.toString())}",
                                                                    "status":
                                                                        "1",
                                                                  },
                                                                );
                                                                bidWaitingBottom(
                                                                  price:
                                                                      "${double.parse(requestDetailController.requestDetailModel!.requestData.price.toString())}",
                                                                );
                                                                acceptRequestController
                                                                    .acceptRequest(
                                                                  accepted:
                                                                      true,
                                                                ); // Mark the request as accepted
                                                                controller
                                                                    .stop(); // Stop the animation controller
                                                                controller
                                                                    .reset();
                                                                isLoadingAccepted =
                                                                    false;
                                                                setState(() {});
                                                                await Future
                                                                    .delayed(
                                                                  const Duration(
                                                                    seconds: 3,
                                                                  ),
                                                                );
                                                                controller1
                                                                    .success();
                                                                await Future
                                                                    .delayed(
                                                                  const Duration(
                                                                    seconds: 1,
                                                                  ),
                                                                );
                                                                controller1
                                                                    .reset();
                                                              },
                                                              child: Text(
                                                                "Accept For ${double.parse(requestDetailController.requestDetailModel!.requestData.price.toString())}${getData.read("Currency")}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
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
                                                          )
                                                        // button(text: "Accept For ${double.parse(requestDetailController.requestDetailModel!.requestData.price.toString())}${getData.read("Currency")}", color: Colors.green,
                                                        //   onPress: (){
                                                        //     setState(() {
                                                        //       isLoadingAccepted = true;
                                                        //     });
                                                        //     socket.emit('Vehicle_Bidding', {
                                                        //       'uid': getData.read("UserLogin")["id"].toString(),
                                                        //       'request_id': requestDetailController.requestDetailModel!.requestData.id.toString(),
                                                        //       'c_id': requestDetailController.requestDetailModel!.requestData.cId.toString(),
                                                        //       'price': "${double.parse(requestDetailController.requestDetailModel!.requestData.price.toString())}",
                                                        //       "status": "1",
                                                        //     });
                                                        //     bidWaitingBottom(price: "${double.parse(requestDetailController.requestDetailModel!.requestData.price.toString())}");
                                                        //     acceptRequestController.acceptRequest(accepted: true); // Mark the request as accepted
                                                        //     controller.stop(); // Stop the animation controller
                                                        //     controller.reset();
                                                        //     isLoadingAccepted =
                                                        //     false;
                                                        //     setState(() {});
                                                        //   }
                                                        // )
                                                        : Center(
                                                            child: ActionSlider
                                                                .standard(
                                                              sliderBehavior:
                                                                  SliderBehavior
                                                                      .stretch,
                                                              rolling: false,
                                                              width: double
                                                                  .infinity,
                                                              height: 49,
                                                              backgroundBorderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                15,
                                                              ),
                                                              foregroundBorderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                10,
                                                              ),
                                                              boxShadow: const [
                                                                BoxShadow(),
                                                              ],
                                                              backgroundColor:
                                                                  Colors.green,
                                                              toggleColor:
                                                                  Colors.white,
                                                              loadingIcon:
                                                                  const Center(
                                                                child: SizedBox(
                                                                  height: 25,
                                                                  width: 25,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                              ),
                                                              successIcon:
                                                                  const Center(
                                                                child: SizedBox(
                                                                  width: 35,
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .check_rounded,
                                                                      color: Colors
                                                                          .green,
                                                                      size: 30,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              icon:
                                                                  const Center(
                                                                child: SizedBox(
                                                                  width: 35,
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .directions_bike,
                                                                      color: Colors
                                                                          .green,
                                                                      size: 25,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              action:
                                                                  (controller1) async {
                                                                controller1
                                                                    .loading(); //starts loading animation
                                                                print(
                                                                  "*****requestID******* ${widget.requestID}",
                                                                );
                                                                acceptRequestController
                                                                    .acceptRequestApi(
                                                                  context:
                                                                      context,
                                                                  requestId: widget
                                                                      .requestID,
                                                                )
                                                                    .then((
                                                                  value,
                                                                ) {
                                                                  Map<String,
                                                                          dynamic>
                                                                      decodedValue =
                                                                      json.decode(
                                                                    value,
                                                                  );
                                                                  if (decodedValue[
                                                                          "Result"] ==
                                                                      true) {
                                                                    print(
                                                                      "-----requestIDSocket/////////////////////-------- ${decodedValue["requestid"].toString()}",
                                                                    );
                                                                    socket.emit(
                                                                      'acceptvehrequest',
                                                                      {
                                                                        'uid': getData
                                                                            .read(
                                                                              "UserLogin",
                                                                            )["id"]
                                                                            .toString(),
                                                                        'request_id':
                                                                            decodedValue["requestid"].toString(),
                                                                        'c_id': requestDetailController
                                                                            .requestDetailModel!
                                                                            .requestData
                                                                            .cId
                                                                            .toString(),
                                                                      },
                                                                    );
                                                                    notificationSoundPlayer
                                                                        .stopNotificationSound();
                                                                    bottomSheet(
                                                                      requestID:
                                                                          decodedValue["requestid"]
                                                                              .toString(),
                                                                    );
                                                                    acceptRequestController
                                                                        .acceptRequest(
                                                                      accepted:
                                                                          true,
                                                                    );
                                                                    controller
                                                                        .stop();
                                                                    controller
                                                                        .reset();
                                                                    isLoadingAccepted =
                                                                        false;
                                                                    setState(
                                                                      () {},
                                                                    );
                                                                  }
                                                                });
                                                                await Future
                                                                    .delayed(
                                                                  const Duration(
                                                                    seconds: 3,
                                                                  ),
                                                                );
                                                                controller1
                                                                    .success();
                                                                await Future
                                                                    .delayed(
                                                                  const Duration(
                                                                    seconds: 1,
                                                                  ),
                                                                );
                                                                controller1
                                                                    .reset();
                                                              },
                                                              child: Text(
                                                                "Accept For ${double.parse(requestDetailController.requestDetailModel!.requestData.price.toString())}${getData.read("Currency")}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
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
                                                          );
                                                    // button(text: "Accept For ${double.parse(requestDetailController.requestDetailModel!.requestData.price.toString())}${getData.read("Currency")}",
                                                    //   color: Colors.green,
                                                    //   onPress: () {
                                                    //     setState(() {
                                                    //       isLoadingAccepted = true;
                                                    //     });
                                                    //     print(
                                                    //         "*****requestID******* ${widget.requestID}");
                                                    //     acceptRequestController.acceptRequestApi(context: context, requestId: widget.requestID).then((value) {
                                                    //       Map<String, dynamic>decodedValue = json.decode(value);
                                                    //       if (decodedValue["Result"] == true) {
                                                    //         print("-----requestIDSocket/////////////////////-------- ${decodedValue["requestid"].toString()}");
                                                    //         socket.emit('acceptvehrequest', {
                                                    //               'uid': getData.read("UserLogin")["id"].toString(),
                                                    //               'request_id': decodedValue["requestid"].toString(),
                                                    //               'c_id': requestDetailController.requestDetailModel!.requestData.cId.toString(),}
                                                    //         );
                                                    //         notificationSoundPlayer.stopNotificationSound();
                                                    //         bottomSheet(requestID: decodedValue["requestid"].toString());
                                                    //         acceptRequestController.acceptRequest(accepted: true);
                                                    //         controller.stop();
                                                    //         controller.reset();
                                                    //         isLoadingAccepted = false;
                                                    //         setState(() {});
                                                    //       }
                                                    //     });
                                                    //   },
                                                    // )
                                                    // ;
                                                  },
                                                ),
                                              ),
                                              acceptRequestController
                                                          .isRequestAccepted !=
                                                      true
                                                  ? Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 8.0,
                                                          ),
                                                          child:
                                                              AnimatedBuilder(
                                                            animation:
                                                                controller,
                                                            builder: (context,
                                                                child) {
                                                              return SizedBox(
                                                                height: 49,
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    ElevatedButton(
                                                                  style:
                                                                      ButtonStyle(
                                                                    padding:
                                                                        const WidgetStatePropertyAll(
                                                                      EdgeInsets
                                                                          .zero,
                                                                    ),
                                                                    elevation:
                                                                        const WidgetStatePropertyAll(
                                                                      0,
                                                                    ),
                                                                    overlayColor:
                                                                        const WidgetStatePropertyAll(
                                                                      Colors
                                                                          .transparent,
                                                                    ),
                                                                    backgroundColor:
                                                                        WidgetStatePropertyAll(
                                                                      Colors
                                                                          .redAccent
                                                                          .withOpacity(
                                                                        0.8,
                                                                      ),
                                                                    ),
                                                                    shape:
                                                                        WidgetStatePropertyAll(
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                          15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    if (!acceptRequestController
                                                                        .isRequestAccepted) {
                                                                      // requestDetailController.requestDetailModel!.requestData.biddingStatus == "1"
                                                                      // ? cancelSocket(requestID: requestDetailController.requestDetailModel!.requestData.id.toString(), cId: requestDetailController.requestDetailModel!.requestData.cId.toString())
                                                                      // : cancelRequestController.cancelRequestApi(context: context, requestId: requestDetailController.requestDetailModel!.requestData.id.toString(), cID: requestDetailController.requestDetailModel!.requestData.cId.toString());
                                                                      // // : rejectBack();
                                                                      requestDetailController.requestDetailModel!.requestData.biddingStatus == "1" &&
                                                                              requestDetailController.requestDetailModel!.requestData.biddAutoStatus ==
                                                                                  "0"
                                                                          ? function()
                                                                          : cancelRequestController
                                                                              .cancelRequestApi(
                                                                              context: context,
                                                                              requestId: requestDetailController.requestDetailModel!.requestData.id.toString(),
                                                                              cID: requestDetailController.requestDetailModel!.requestData.cId.toString(),
                                                                            );
                                                                      notificationSoundPlayer
                                                                          .stopNotificationSound();
                                                                    }
                                                                  },
                                                                  child: Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                          15,
                                                                        ),
                                                                        child:
                                                                            LinearProgressIndicator(
                                                                          minHeight:
                                                                              49,
                                                                          value:
                                                                              controller.value,
                                                                          backgroundColor: Colors
                                                                              .redAccent
                                                                              .withOpacity(
                                                                            0.1,
                                                                          ),
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        "Reject",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              whiteColor,
                                                                          letterSpacing:
                                                                              0.4,
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
                                                    )
                                                  : const SizedBox(),
                                              requestDetailController
                                                              .requestDetailModel!
                                                              .requestData
                                                              .biddingStatus ==
                                                          "1" &&
                                                      requestDetailController
                                                              .requestDetailModel!
                                                              .requestData
                                                              .biddAutoStatus ==
                                                          "0"
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 19,
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            "Offer your fare:",
                                                            style: TextStyle(
                                                              color: notifier
                                                                  .textColor,
                                                              fontSize: 16,
                                                              fontFamily: FontFamily
                                                                  .sofiaProBold,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 19,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 8.0,
                                                            right: 3,
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Expanded(
                                                                child: SizedBox(
                                                                  height: 60,
                                                                  child: ListView
                                                                      .separated(
                                                                    itemCount: requestDetailController
                                                                        .requestDetailModel!
                                                                        .requestData
                                                                        .driOfferLimite
                                                                        .length,
                                                                    shrinkWrap:
                                                                        true,
                                                                    separatorBuilder: (
                                                                      context,
                                                                      index,
                                                                    ) =>
                                                                        const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    physics:
                                                                        const BouncingScrollPhysics(),
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    itemBuilder:
                                                                        (
                                                                      context,
                                                                      index,
                                                                    ) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                            () {
                                                                              selectBidIndex = index;
                                                                              print(
                                                                                "PRATIK",
                                                                              );
                                                                              socket.emit(
                                                                                'Vehicle_Bidding',
                                                                                {
                                                                                  'uid': getData
                                                                                      .read(
                                                                                        "UserLogin",
                                                                                      )["id"]
                                                                                      .toString(),
                                                                                  'request_id': requestDetailController.requestDetailModel!.requestData.id.toString(),
                                                                                  'c_id': requestDetailController.requestDetailModel!.requestData.cId.toString(),
                                                                                  'price': requestDetailController.requestDetailModel!.requestData.driOfferLimite[index],
                                                                                  "status": "1",
                                                                                },
                                                                              );
                                                                              bidWaitingBottom(
                                                                                price: "${requestDetailController.requestDetailModel!.requestData.driOfferLimite[index]}",
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              60,
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                27,
                                                                          ),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                              20,
                                                                            ),
                                                                            color: selectBidIndex == index
                                                                                ? appColor
                                                                                : notifier.containerColor,
                                                                            border:
                                                                                Border.all(
                                                                              color: selectBidIndex == index
                                                                                  ? appColor
                                                                                  : Colors.grey.withOpacity(
                                                                                      0.3,
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Text(
                                                                                "${getData.read("Currency")}${requestDetailController.requestDetailModel!.requestData.driOfferLimite[index]}",
                                                                                style: TextStyle(
                                                                                  fontSize: 17,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: selectBidIndex == index ? whiteColor : notifier.textColor,
                                                                                  letterSpacing: 0.4,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  editBidBottomSheet();
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  height: 60,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        30,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      20,
                                                                    ),
                                                                    color:
                                                                        appColor,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            23,
                                                                        child: Image
                                                                            .asset(
                                                                          "assets/image/pen.png",
                                                                          color:
                                                                              whiteColor,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
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
                                        isLoadingAccepted == true
                                            ? Positioned(
                                                top: 0,
                                                right: 0,
                                                left: 0,
                                                bottom: 0,
                                                child: BackdropFilter(
                                                  filter: ui.ImageFilter.blur(
                                                    sigmaX: 1.5,
                                                    sigmaY: 1.5,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 50,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(
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
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(child: CircularProgressIndicator(color: appColor));
          },
        ),
      ),
    );
  }

  function() {
    socket.emit('Driver_Bidding_Req_Reject', {
      'uid': getData.read("UserLogin")["id"].toString(),
      'request_id':
          requestDetailController.requestDetailModel!.requestData.id.toString(),
      'c_id': requestDetailController.requestDetailModel!.requestData.cId
          .toString(),
    });
    cancelRequestController.cancelRequestApi(
      context: context,
      requestId:
          requestDetailController.requestDetailModel!.requestData.id.toString(),
      cID: requestDetailController.requestDetailModel!.requestData.cId
          .toString(),
    );
    print("Doneeeeeeeeee");
  }

  Future editBidBottomSheet() {
    return Get.bottomSheet(
      isScrollControlled: true,
      StatefulBuilder(
        builder: (context, setState) {
          return BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                color: notifier.background,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Offer your fare:".tr,
                    style: TextStyle(
                      color: notifier.textColor,
                      fontSize: 16,
                      fontFamily: FontFamily.sofiaProBold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${getData.read("Currency")}${bidController.text}",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontSize: 30,
                      fontFamily: FontFamily.sofiaProBold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: bidController,
                    // obscureText: loginController.obscureText,
                    onChanged: (value) {
                      setState(() {
                        bidController.text = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    cursorColor: appColor,
                    style: TextStyle(
                      fontFamily: FontFamily.sofiaProRegular,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: notifier.textColor,
                      letterSpacing: 0.3,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.only(top: 15, left: 12),
                      hintText: "Enter your Bid".tr,
                      hintStyle: TextStyle(
                        fontFamily: FontFamily.sofiaProRegular,
                        fontSize: 15,
                        color: Colors.grey.shade400,
                        letterSpacing: 0.3,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
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
                  const SizedBox(height: 20),
                  button(
                    text: "Bid".tr,
                    color: appColor,
                    onPress: () {
                      socket.emit('Vehicle_Bidding', {
                        'uid': getData.read("UserLogin")["id"].toString(),
                        'request_id': requestDetailController
                            .requestDetailModel!.requestData.id
                            .toString(),
                        'c_id': requestDetailController
                            .requestDetailModel!.requestData.cId
                            .toString(),
                        'price': bidController.text,
                        "status": "1",
                      });
                      Get.back();
                      bidWaitingBottom(price: bidController.text);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _addMarker11(
    LatLng position,
    String id,
    BitmapDescriptor descriptor,
    address,
  ) async {
    final Uint8List markIcon = await getImages11(
      "assets/image/pick_up.png",
      80,
    );
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(markIcon),
      position: position,
      onTap: () {
        showDialog(
          barrierColor: Colors.transparent,
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  alignment: const Alignment(0, -0.25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                  child: Container(
                    width: 50,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "$address",
                          maxLines: 2,
                          style: TextStyle(
                            color: notifier.textColor,
                            fontSize: 15,
                            fontFamily: FontFamily.sofiaProRegular,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
    markers11[markerId] = marker;
  }

  Future _addMarker2(
    LatLng position,
    String id,
    BitmapDescriptor descriptor,
  ) async {
    final Uint8List markIcon = await getImages11("assets/image/drop.png", 80);
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(markIcon),
      position: position,
      onTap: () {
        showDialog(
          barrierColor: Colors.transparent,
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  alignment: const Alignment(0, -0.25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                  child: Container(
                    width: 50,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "2",
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
    markers11[markerId] = marker;
  }

  _addMarker3(String id, List<Map<String, String>> dropOffData) async {
    for (int a = 0; a < dropOffPoints.length; a++) {
      final Uint8List markIcon = await getImages11("assets/image/drop.png", 80);
      MarkerId markerId = MarkerId(id[a]);

      // Assuming _dropOffPoints[a] is of type PointLatLng, convert it to LatLng
      LatLng position = LatLng(
        dropOffPoints[a].latitude,
        dropOffPoints[a].longitude,
      );

      Marker marker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.fromBytes(markIcon),
        position: position,
        onTap: () {
          String title = dropOffData[a]["title"] ?? "Unknown Title";
          String subtitle = dropOffData[a]["subtitle"] ?? "No Address Provided";

          showDialog(
            barrierColor: Colors.transparent,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Dialog(
                    alignment: const Alignment(0, -0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                    child: Container(
                      width: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$title $subtitle",
                            maxLines: 2,
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 15,
                              fontFamily: FontFamily.sofiaProRegular,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      );

      markers11[markerId] = marker;
    }
  }

  addPolyLine11(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: appColor,
      // points: [...polylineCoordinates,..._dropOffPoints],
      points: polylineCoordinates,
      width: 4,
    );
    polylines11[id] = polyline;
    setState(() {});
  }

  Future getDirections11({
    required PointLatLng lat1,
    required List<PointLatLng> dropOffPoints,
  }) async {
    List<LatLng> polylineCoordinates = [];
    List<PointLatLng> allPoints = [lat1, ...dropOffPoints];

    for (int i = 0; i < allPoints.length - 1; i++) {
      PointLatLng point1 = allPoints[i];
      PointLatLng point2 = allPoints[i + 1];

      PolylineResult result = await polylinePoints11.getRouteBetweenCoordinates(
        Config.mapKey,
        point1,
        point2,
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        // Handle the case where no route is found
      }
    }

    addPolyLine11(polylineCoordinates);
  }

  Future bottomSheet({required String requestID}) {
    return Get.bottomSheet(
      isDismissible:
          requestDetailController.requestDetailModel!.requestData.status == "1"
              ? false
              : true,
      isScrollControlled: true,
      enableDrag:
          requestDetailController.requestDetailModel!.requestData.status == "1"
              ? false
              : true,
      WillPopScope(
        onWillPop: () async {
          currentIndexBottom = 0;
          setState(() {});
          return requestDetailController
                      .requestDetailModel!.requestData.status ==
                  "1"
              ? await Get.offAll(const BottomBarScreen())
              : true;
          // return true;
        },
        child: StatefulBuilder(
          builder: (context, setState) {
            return BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
              child: Container(
                width: Get.width,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RotatedBox(
                                        quarterTurns: 2,
                                        child: Icon(
                                          CupertinoIcons.location_north_fill,
                                          size: 20,
                                          color: appColor,
                                        ),
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                              "assets/image/loaction_circle.svg",
                                            ),
                                          ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                  "+++++++++++++++++++++++ ${timeData[index]}",
                                );
                                // timeController.timeApi(context: context, requestId: requestID, cId: requestDetailController.requestDetailModel!.requestData.cId.toString(), time: timeData[index].toString(),).then((value) {
                                //   Map<String, dynamic> decodedValue = json.decode(value);
                                // if(decodedValue["Result"] == true){
                                socket.emit('Vehicle_Time_update', {
                                  'uid': getData
                                      .read("UserLogin")["id"]
                                      .toString(),
                                  'request_id': requestID,
                                  'c_id': requestDetailController
                                      .requestDetailModel!.requestData.cId
                                      .toString(),
                                  'time': timeData[index].toString(),
                                });
                                isLoading = false;
                                homeStatus = 0;
                                requestDetailController
                                    .requestDetailApi(requestId: requestID)
                                    .then((value) {
                                  setState(() {});
                                  Get.to(
                                    MapRideScreen(
                                      time: timeData[index].toString(),
                                      requestId: requestID,
                                    ),
                                  );
                                  setState(() {});
                                });
                                print('ELELELELELELELELE:__${isLoading}');

                                //   }else{
                                //     snackBar(context: context, text: "Something went Wrong");
                                //   // }?
                                //   // },
                                //   );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 25),
                        button(
                          text: "Default Time",
                          color: appColor,
                          onPress: () {
                            Get.offAll(
                              MapRideScreen(
                                requestId: requestID,
                                time: requestDetailController
                                    .requestDetailModel!.requestData.totMinute
                                    .toString(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    isLoading == true
                        ? BackdropFilter(
                            filter: ui.ImageFilter.blur(
                              sigmaX: 1.5,
                              sigmaY: 1.5,
                            ),
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
                                  ),
                                ),
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
      ),
    );
  }

  Future<void> bidWaitingBottom({required String price}) {
    notificationSoundPlayer.stopNotificationSound();
    return Get.bottomSheet(
      isScrollControlled: true,
      // enableDrag: false,
      // isDismissible: false,
      StatefulBuilder(
        builder: (context, setState) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Opacity(
                opacity: 0.8,
                child: Container(
                  alignment: Alignment.center,
                  height: Get.height,
                  width: Get.width,
                  padding: const EdgeInsets.all(16),
                  color: Colors.black54,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Offering your fare ${getData.read("Currency")}$price",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Wait for the reply",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                    color: notifier.background,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(13),
                        child: Row(
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/image/rating_filled.svg",
                                      color: Colors.amber.shade800,
                                    ),
                                    Text(
                                      "${requestDetailController.requestDetailModel!.requestData.rating}(${requestDetailController.requestDetailModel!.requestData.review})",
                                      style: TextStyle(
                                        color: notifier.textColor,
                                        fontSize: 16,
                                        letterSpacing: 0.5,
                                        fontFamily: FontFamily.sofiaProRegular,
                                      ),
                                    ),
                                  ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RotatedBox(
                                        quarterTurns: 2,
                                        child: Icon(
                                          CupertinoIcons.location_north_fill,
                                          size: 20,
                                          color: appColor,
                                        ),
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                              "assets/image/loaction_circle.svg",
                                            ),
                                          ),
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
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 25),
                                      Text(
                                        "${getData.read("Currency")}$price",
                                        style: TextStyle(
                                          color: appColor,
                                          fontSize: 20,
                                          fontFamily: FontFamily.sofiaProBold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Offering(
                        second: requestDetailController
                            .requestDetailModel!.requestData.biddExTime,
                        onTap: () {
                          socket.emit('Vehicle_Bidding', {
                            'uid': getData.read("UserLogin")["id"].toString(),
                            'request_id': requestDetailController
                                .requestDetailModel!.requestData.id
                                .toString(),
                            'c_id': requestDetailController
                                .requestDetailModel!.requestData.cId
                                .toString(),
                            'price': price.toString(),
                            'status': "1",
                          });
                          print("-+-+++-++**//7856514566566 SuccessFully");
                          scaffoldMessengerKey.currentState?.showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Offer Send Successfully",
                                style: TextStyle(
                                  fontFamily: FontFamily.sofiaProBold,
                                  fontSize: 14,
                                ),
                              ),
                              backgroundColor: appColor,
                              behavior: SnackBarBehavior.floating,
                              elevation: 0,
                              duration: const Duration(seconds: 3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Offering extends StatefulWidget {
  void Function() onTap;
  final int second;
  Offering({super.key, required this.onTap, required this.second});

  @override
  State<Offering> createState() => _OfferingState();
}

class _OfferingState extends State<Offering> with TickerProviderStateMixin {
  late AnimationController controller1;
  final NotificationSoundPlayer notificationSoundPlayer =
      NotificationSoundPlayer();

  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.second),
    )..addListener(() {
        setState(() {});
        if (controller1.isCompleted) {
          controller1.stop();
          Get.back();
          Future.delayed(const Duration(milliseconds: 200), () {
            showSnackBar(onTap: widget.onTap);
          });
        }
      });

    controller1.forward();
  }

  @override
  void dispose() {
    controller1.dispose();
    notificationSoundPlayer.stopNotificationSound();
    super.dispose();
  }

  void showSnackBar({required void Function() onTap}) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Your offer expired",
              style: TextStyle(
                fontFamily: FontFamily.sofiaProBold,
                fontSize: 14,
              ),
            ),
            GestureDetector(
              // onTap: onTap,
              onTap: () {
                onTap();
                scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              },
              child: const Text(
                "SEND AGAIN",
                style: TextStyle(
                  fontFamily: FontFamily.sofiaProBold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: appColor,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        duration: const Duration(seconds: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      minHeight: 6.5,
      backgroundColor: Colors.white,
      color: appColor,
      value: 1.0 - controller1.value,
      borderRadius: BorderRadius.circular(35),
    );
  }
}
