// ignore_for_file: unused_import

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../config/config.dart';
import '../../config/data_store.dart';
import '../../config/socket.dart';
import '../../controller/update_location_controller.dart';
import '../../utils/colors.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../auth_screen/splash_screen.dart';

class MapLocationUpdateController extends GetxController implements GetxService {

  UpdateLocationController updateLocationController = Get.put(UpdateLocationController());

  List<PointLatLng> dropOffPoints = [];
  Map<MarkerId, Marker> markers11 = {};
  Map<PolylineId, Polyline> polylines11 = {};
  List<LatLng> polylineCoordinates11 = [];
  PolylinePoints polylinePoints11 = PolylinePoints();
  StreamSubscription<Position>? positionStreamSubscription;
  late IO.Socket socket;
  double carDegree = 0.0;


  @override
  void onInit() {
    super.onInit();
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io(Config.socketUrl, <String, dynamic>{'transports': ['websocket'], 'autoConnect': false});
    socket.connect();
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
  }

  void startLiveTracking() {
    positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 15),
    ).listen((Position position) {
      movingLat = position.latitude;
      movingLong = position.longitude;

      updateMarker(LatLng(position.latitude, position.longitude), "origin", "assets/image/1724501643194download91.png");
      getDirections11(lat1: PointLatLng(position.latitude, position.longitude), dropOffPoints: dropOffPoints,);
      carDegree = calculateDegrees(LatLng(position.latitude, position.longitude), LatLng(position.latitude, position.longitude));
      sendLiveLocation(position.latitude, position.longitude);
    });
  }

  void stopLiveTracking() {
    if (positionStreamSubscription != null) {
      positionStreamSubscription!.cancel();
      positionStreamSubscription = null;
    }
  }

  void sendCurrentLocation() async {
    Position position = await _determinePosition();
    sendLocation(position.latitude, position.longitude);
  }

  void sendLocation(double lat1, double long1) {
    socket.emit('homemap', {
      'uid': getData.read("UserLogin")["id"].toString(),
      'lat': lat1.toString(),
      'long': long1.toString(),
      'status': "off"
    });
    updateLocationController.updateLocationAPi(lat: lat1.toString(), long: long1.toString(), status: "off");
  }

  void sendLiveLocation(double lat1, double long1) {
    print("//////////lat1//////////// $lat1");
    print("//////////long1//////////// $long1");
    socket.emit('homemap', {
      'uid': getData.read("UserLogin")["id"].toString(),
      'lat': lat1.toString(),
      'long': long1.toString(),
      'status': "on"
    });
  }

  Future<Uint8List> getImages11(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<Uint8List> resizeImage(Uint8List data, {required int targetWidth, required int targetHeight}) async {
    // Decode the image
    final ui.Codec codec = await ui.instantiateImageCodec(data);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    // Original dimensions
    final int originalWidth = frameInfo.image.width;
    final int originalHeight = frameInfo.image.height;

    // Calculate the aspect ratio
    final double aspectRatio = originalWidth / originalHeight;

    // Determine the dimensions to maintain the aspect ratio
    int resizedWidth, resizedHeight;
    if (originalWidth > originalHeight) {
      resizedWidth = targetWidth;
      resizedHeight = (targetWidth / aspectRatio).round();
    } else {
      resizedHeight = targetHeight;
      resizedWidth = (targetHeight * aspectRatio).round();
    }

    // Resize image
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Size size = Size(resizedWidth.toDouble(), resizedHeight.toDouble());
    final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

    // Paint image
    final Paint paint = Paint()..isAntiAlias = true;
    canvas.drawImageRect(frameInfo.image, Rect.fromLTWH(0.0, 0.0, originalWidth.toDouble(), originalHeight.toDouble()), rect, paint);

    final ui.Image resizedImage = await recorder.endRecording().toImage(resizedWidth, resizedHeight);

    final ByteData? resizedByteData = await resizedImage.toByteData(format: ImageByteFormat.png);
    return resizedByteData!.buffer.asUint8List();
  }

  Future<Uint8List> getNetworkImage(String path, {int targetWidth = 80, int targetHeight = 80}) async {
    final completer = Completer<ImageInfo>();
    var image = AssetImage(path);
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) => completer.complete(info)),
    );
    final ImageInfo imageInfo = await completer.future;

    final ByteData? byteData = await imageInfo.image.toByteData(
      format: ImageByteFormat.png,
    );

    Uint8List resizedImage = await resizeImage(Uint8List.view(byteData!.buffer), targetWidth: targetWidth, targetHeight: targetHeight);
    return resizedImage;
  }

  updateMarker(LatLng position, String id, String imageUrl) async {
    print("1111111111111111111");
    final Uint8List markIcon = await getNetworkImage(imageUrl);
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(markIcon),
      position: position,
        rotation: carDegree,
        anchor: const Offset(0.5, 0.5)
    );
    print("2222222222222222222");
    markers11[markerId] = marker;


    if (markers11.containsKey(markerId)) {
      final Marker oldMarker = markers11[markerId]!;
      print("3333333333333333333");
      // Create a new marker with the updated position, keeping other properties same
      final Marker updatedMarker = oldMarker.copyWith(
        positionParam: position,  // Update the marker's position
      );

      // setState(() {

      markers11[markerId] = updatedMarker;

      update();
      print("4444444444444444444");
      // });
    }
  }

  Future addMarker2(LatLng position, String id) async {
    final Uint8List markIcon = await getNetworkImage("assets/image/pick_up.png");
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(markIcon),
      position: position,
      onTap: () {
        // Add any desired behavior for when the marker is tapped
      },
    );
    markers11[markerId] = marker;
  }

  Future<void> removeMarker(String id) async {
    MarkerId markerId = MarkerId(id);
    if (markers11.containsKey(markerId)) {
      markers11.remove(markerId);
      update();
    }
  }

  Future addMarkerCurrent(LatLng position, String id, BitmapDescriptor descriptor) async {
    final Uint8List markIcon = await getNetworkImage("assets/image/pick_up.png");
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(markIcon),
      position: position,
      onTap: () {
        // Add any desired behavior for when the marker is tapped
      },
    );
    markers11[markerId] = marker;
  }

  addMarker3(String id) async {
    for (int a = 0; a < dropOffPoints.length; a++) {
      final Uint8List markIcon = await getNetworkImage("assets/image/drop.png");
      MarkerId markerId = MarkerId(id[a]);

      LatLng position = LatLng(dropOffPoints[a].latitude, dropOffPoints[a].longitude);

      Marker marker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.fromBytes(markIcon),
        position: position,
        onTap: () {
          // Add any desired behavior for when the marker is tapped
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
      points: polylineCoordinates,
      width: 4,
    );
    polylines11[id] = polyline;
  }

  Future getDirections11({required PointLatLng lat1, required List<PointLatLng> dropOffPoints}) async {
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
      }
    }

    addPolyLine11(polylineCoordinates);
  }

  static double calculateDegrees(LatLng startPoint, LatLng endPoint) {
    final double startLat = toRadians(startPoint.latitude);
    final double startLng = toRadians(startPoint.longitude);
    final double endLat = toRadians(endPoint.latitude);
    final double endLng = toRadians(endPoint.longitude);

    final double deltaLng = endLng - startLng;

    final double y = math.sin(deltaLng) * math.cos(endLat);
    final double x = math.cos(startLat) * math.sin(endLat) -
        math.sin(startLat) * math.cos(endLat) * math.cos(deltaLng);

    final double bearing = math.atan2(y, x);
    return (toDegrees(bearing) + 360) % 360;
  }

  static double toRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  static double toDegrees(double radians) {
    return radians * (180.0 / math.pi);
  }

}



