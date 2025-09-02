// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qareeb/screen/auth_screen/splash_screen.dart';
import '../config/config.dart';
import '../config/data_store.dart';
import '../model/ride_start_model.dart';
import '../widget/common.dart';
// In RideStartController.dart

class RideStartController extends GetxController implements GetxService {
  RideStartModel? rideStartModel;
  bool isLoading = false;
  bool isLoad = false;
  bool isCircle = false;

  Future rideStartApi({required context, required String requestId}) async {
    if (isLoad) {
      return;
    }
    isLoad = true;
    update();

    Map body = {
      "uid": getData.read("UserLogin")['id'],
      "request_id": requestId,
      "lat": movingLat.toString(),
      "lon": movingLong.toString(),
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrl + Config.rideStart),
        body: jsonEncode(body),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
        },
      );

      // ✅ This logic now prints ANY non-200 response directly to your console.
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["Result"] == true) {
          // Success case
          rideStartModel = rideStartModelFromJson(response.body);
          isLoading = true;
          isLoad = false;
          update();
          return response.body; // Return successful data
        } else {
          // Business logic error (e.g., Result: false)
          print("--- BACKEND LOGIC ERROR ---");
          print("Status Code: ${response.statusCode}");
          print("Response Body: ${response.body}");
          print("---------------------------");
          snackBar(
              context: context,
              text: data["message"] ?? "An unknown error occurred.");
        }
      } else {
        // Handles other errors like 404, 500, etc.
        print("--- HTTP ERROR ---");
        print("Status Code: ${response.statusCode}");
        print(
            "Response Body: ${response.body}"); // See exactly what the server sent
        print("------------------");
        snackBar(
            context: context, text: "Server error: ${response.statusCode}");
      }
    } catch (e) {
      // Handles network failures (no internet, server down)
      print("--- NETWORK/CLIENT ERROR ---");
      print(e.toString());
      print("----------------------------");
      snackBar(context: context, text: "Failed to connect to the server.");
    }

    // If we reach here, it means an error occurred.
    isLoad = false;
    update();
    return null; // Explicitly return null on failure
  }
}
