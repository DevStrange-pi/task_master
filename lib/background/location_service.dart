import 'dart:async';
import 'dart:convert';
// import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_master/utilities/utilities.dart';

import '../constants/strings.dart';
import '../models/employee/emp_location_track_response_model.dart';
import '../network/http_req.dart';

@pragma('vm:entry-point')
void backgroundServiceOnStart(ServiceInstance service) async {
  // DartPluginRegistrant.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String baseUrl = prefs.getString('BASE_URL') ?? '';
  String token = prefs.getString(SpString.token)!;
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude).timeout(const Duration(seconds: 5));
    Placemark place = placemarks.first;

    String name = "${place.name ?? ''}, ${place.subLocality ?? ''}";
    String address =
        "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    final body = {
      "name": name,
      // "Office HQ 1",
      "address": address,
      // "Connaught Place, Delhi",
      "latitude": position.latitude,
      "longitude": position.longitude,
    };
    int? empId = prefs.getInt(SpString.id) ?? 0;
    if (empId != 0 && baseUrl.isNotEmpty) {
      await trackLocation(baseUrl, token, empId, body);
      logToFile(
          "Location Service Started: ${DateTime.now()}");
      Timer.periodic(const Duration(minutes: 15), (timer) async {
        await trackLocation(baseUrl, token, empId, body);
      });
    }
  } catch (e) {
    print('Reverse geocoding failed: ${e.toString()}');
    logToFile('Reverse geocoding failed: ${e.toString()}');
  }
}

@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance service) {
  return true;
}

Future<void> trackLocation(
    String baseUrl, String token, int empId, Map<String, Object> body) async {
  try {
    String newUrl = "$baseUrl/employee/$empId/track-location";
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var resp =
        await HttpReq.postApi(headers: headers, apiUrl: newUrl, body: body);
    var respBody = json.decode(resp!.body);
    EmpLocationTrackResponseModel locationTrackResponseModel =
        EmpLocationTrackResponseModel.fromJson(respBody);
    print("Location Data  : ${locationTrackResponseModel.toJson()}");
    // LoginResponseModel loginData = LoginResponseModel.fromJson(respBody);
    if (resp.statusCode == 200) {
      // myBotToast(respBody["message"]);
      // myBotToast("Location Data : ${locationTrackResponseModel.toJson()}",duration: const Duration(seconds: 2));
      logToFile(
          "Location Data ${DateTime.now()} : ${locationTrackResponseModel.toJson()}");
    } else {
      print('Failed to send location: ${resp.body}');
      logToFile(
          "Failed to send location ${DateTime.now()}: ${resp.body}");
      // myBotToast('Failed to send location: ${resp.body}', duration: const Duration(seconds: 2));
      // myBotToast("Failed to send location: ${resp.body}");
    }
  } catch (e) {
    print(e.toString());
  }
}

Future<void> stopService() async {
  final service = FlutterBackgroundService();
  if (await service.isRunning()) {
    logToFile("Stopping Location Service... ${DateTime.now()}");
    service.invoke('stopService');
  }
}
