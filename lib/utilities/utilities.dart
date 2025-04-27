import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'dart:math' as Math;
import 'dart:ui' as ui;

// import 'package:bot_toast/bot_toast.dart';
// import 'package:cocolife/screens/auth/intro.dart';
// import 'package:cocolife/screens/pdf_viewer.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_url.dart';
import '../constants/strings.dart';
import '../network/http_req.dart';
import '../routes/app_routes.dart';
import 'circular_loader.dart';
// import 'package:image/image.dart' as Im;
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:mqtt5_client/mqtt5_client.dart';
// import 'package:mqtt5_client/mqtt5_server_client.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../constants/app_url.dart';
// import '../constants/strings.dart';
// import '../enums/auth_enum.dart';
// import '../main.dart';
// import '../screens/webview_page.dart';
// import '../services/mqtt_service.dart';

// import 'package:sip_ua/sip_ua.dart';

myBotToast(String text, {s, duration}) =>
    BotToast.showText(text: text, duration: Duration(seconds: duration ?? 4));

class AppUtility {
  // static bool isSipRegistered(helper) {
  //   return ((helper==null)||(helper.registerState.state != RegistrationStateEnum.REGISTERED)) ? false : true;
  // }

  // static Future<String?> deviceId() async {
  //   try {
  //     final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //     if (Platform.isAndroid) {
  //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //       return androidInfo.id;
  //     } else {
  //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //       return iosInfo.identifierForVendor;
  //     }
  //   } catch (e) {
  //     myBotToast(text: "${e.toString()}");
  //     return null;
  //   }
  // }

  // static Future<DateTime?> datePicker(BuildContext? context) async {
  //   return await DatePicker.showDatePicker(context!,
  //       minTime: DateTime(1990),
  //       maxTime:  DateTime(2050),
  //       currentTime: DateTime.now(),
  //       theme: DatePickerTheme(backgroundColor: Colors.white));
  // }

  // static Future<File?> imagePicker() async {
  //   try {
  //     ImagePicker _picker = ImagePicker();
  //     XFile? pickedFile = await _picker.pickImage(
  //         source: ImageSource.camera,
  //         maxHeight: 400,
  //         maxWidth: 360,
  //         imageQuality: 90);
  //     if (pickedFile != null && pickedFile.path != null) {
  //       File file = File(pickedFile.path);
  //       if (file != null) {
  //         int bytes = await file.length();
  //         double size = getFileSize(bytes);
  //         if (size <= 5) {
  //           print("Image croping");
  //           // File croppedFile = await ImageCropper().cropImage(
  //           //     sourcePath: file.path,
  //           //     aspectRatioPresets: Platform.isAndroid
  //           //         ? [
  //           //       CropAspectRatioPreset.square,
  //           //       CropAspectRatioPreset.ratio3x2,
  //           //       CropAspectRatioPreset.original,
  //           //       CropAspectRatioPreset.ratio4x3,
  //           //       CropAspectRatioPreset.ratio16x9
  //           //     ]
  //           //         : [
  //           //       CropAspectRatioPreset.original,
  //           //       CropAspectRatioPreset.square,
  //           //       CropAspectRatioPreset.ratio3x2,
  //           //       CropAspectRatioPreset.ratio4x3,
  //           //       CropAspectRatioPreset.ratio5x3,
  //           //       CropAspectRatioPreset.ratio5x4,
  //           //       CropAspectRatioPreset.ratio7x5,
  //           //       CropAspectRatioPreset.ratio16x9
  //           //     ],
  //           //     androidUiSettings: AndroidUiSettings(
  //           //         toolbarTitle: 'Cropper',
  //           //         toolbarColor: Colors.deepOrange,
  //           //         toolbarWidgetColor: Colors.white,
  //           //         initAspectRatio: CropAspectRatioPreset.original,
  //           //         lockAspectRatio: false),
  //           //     iosUiSettings: IOSUiSettings(
  //           //       title: 'Cropper',
  //           //     ));
  //           return file;
  //         } else {
  //           myBotToast(text: "File size should be less than 5 mb");
  //         }
  //       } else {
  //         myBotToast(text: "File can't be blank");
  //       }
  //     } else {
  //       myBotToast(text: "Picked file can't be blank");
  //     }
  //   } catch (e) {
  //     print("Exception : $e");
  //   }
  //   return null;
  // }

  static double getFileSize(int bytes) {
    if (bytes == 0) return 0.0;
    double i = (log(bytes) / log(1000000));
    return i;
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Future<bool> isInternetConnected() async {
    print("isInternetConnected");
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> requestPermissions() async {
    debugPrint("Called requestPermissions");
    await [Permission.camera, Permission.microphone, Permission.storage]
        .request();
  }

  static Future<bool> checkCameraPermission() async {
    bool status = false;
    PermissionStatus permissionStatus = await Permission.camera.request();
    bool isLimited = await Permission.camera.request().isLimited;
    if (permissionStatus.isGranted == true || isLimited == true) {
      status = true;
    }
    // status = await Permission.camera.status.isGranted;
    print("camera_permission_status $status, ${permissionStatus} , $isLimited");
    if (status == false) {
      await [Permission.camera].request();
      bool newStatus = await Permission.camera.isGranted;
      status = newStatus;
    }
    return status;
  }

  static Future<bool> checkStoragePermission() async {
    bool status = await Permission.storage.status.isGranted;
    if (status == false) {
      await [Permission.storage].request();
    }
    bool newStatus = await Permission.storage.isGranted;
    return newStatus;
  }

  // static Future<File> getFileFromUrl({String? name, String? url}) async {
  //   print("DOCURL $url");
  //   var fileName = "test";
  //   if (name != null) {
  //     fileName = name;
  //   }
  //   try {
  //     var data = await http.get(Uri.parse(url!.trim()));
  //     var bytes = data.bodyBytes;
  //     // var dir = await getApplicationDocumentsDirectory();
  //     // File file = File("${dir.path}/" + fileName + ".pdf");
  //     // print(dir.path);
  //     // File urlFile = await file.writeAsBytes(bytes);
  //     // return urlFile;
  //     return File("");
  //   } catch (e) {
  //     throw Exception("Error opening url file");
  //   }
  // }

  // static String convertLocalDateToServerDate(String inputDate) {
  //   DateTime? dateTime = DateFormat.yMMMMd().parse(inputDate);
  //   String serverDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime);
  //   return serverDate;
  // }

  // static String convertServerDateToLocalDate(String inputDate) {
  //   DateTime? dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(inputDate);
  //   String serverDate = DateFormat.yMMMMd().format(dateTime);
  //   return serverDate;
  // }

  // static String convertEloaListDateToLocalDate(String inputDate) {
  //   DateTime? dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(inputDate);
  //   String serverDate = DateFormat.yMMMMd().format(dateTime);
  //   return serverDate;
  // }

  static getDDMMYY(String inputDate) {
    if (inputDate == "") return "";

    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    String dateTime = "";
    int day = DateTime.parse(inputDate).day;
    if (day < 10) {
      dateTime = "0$day-";
    } else {
      dateTime = "$day-";
    }
    dateTime += months[DateTime.parse(inputDate).month - 1] +
        "-" +
        DateTime.parse(inputDate).year.toString();
    return dateTime;
  }

  // Future<File> compressImage(File imageFile) async {
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;
  //   int rand = new Math.Random().nextInt(10000);
  //   Im.Image? image = Im.decodeImage(imageFile.readAsBytesSync());
  //   Im.Image smallerImage = Im.copyResize(image!,
  //       width: 400,
  //       height: 400); // choose the size here, it will maintain aspect ratio

  //   File compressedImage = new File('$path/img_$rand.jpg')
  //     ..writeAsBytesSync(Im.encodeJpg(smallerImage, quality: 85));
  //   return compressedImage;
  // }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData? data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<bool> logout() async {
    SharedPreferences? prefs;
    prefs = await SharedPreferences.getInstance();
    CircularLoader circularLoader = Get.find<CircularLoader>();
    circularLoader.showCircularLoader();
    String token = prefs.getString(SpString.token)!;
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var resp = await HttpReq.postApi(
        apiUrl: AppUrl().logout, headers: headers);
    var respBody = json.decode(resp!.body);
    if (resp.statusCode == 200) {
      keepSomeSpValues();
      Get.offAllNamed(AppRoutes.introPage);
      myBotToast(respBody["message"]);
      circularLoader.hideCircularLoader();
      return true;
    } else {
      circularLoader.hideCircularLoader();
      myBotToast(respBody["message"]);
      return false;
    }
  }
  void keepSomeSpValues()async{
    SharedPreferences? prefs;
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // Future<void> startMQTT() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? phoneNo = prefs.getString(AppPrefs.MOBILE_NUMBER);
  //   mqttClient = MqttServerClient(hostName, '');
  //   MqttService mqttService = MqttService(hostName: hostName, port: 1883);
  //   if (AppUtility.isMqttConnected() == false) {
  //     await mqttService.startService();
  //     if (mqttClient != null && AppUtility.isMqttConnected()) {
  //       debugPrint("Subscribing to VIDEO-MOBILEAPP-$phoneNo topic");
  //       mqttClient!.subscribe("VIDEO-MOBILEAPP-$phoneNo", MqttQos.exactlyOnce);
  //     }
  //   }
  // }

  // static bool isMqttConnected({var client}) {
  //   if (mqttClient == null && client == null) return false;
  //   return (client == null ? mqttClient : client).connectionStatus.state ==
  //           MqttConnectionState.connected
  //       ? true
  //       : false;
  // }

  // static Future<void> launchURL(String _url) async => await canLaunch(_url)
  //     ? await launch(_url)
  //     : throw 'Could not launch $_url';

  // static Future<String?> getFirebaseToken() async {
  //   String? firebaseToken = await FirebaseMessaging.instance.getToken();
  //   return firebaseToken;
  // }

  // static playRingtone() {
  //   try {
  //     FlutterRingtonePlayer.play(
  //       android: AndroidSounds.ringtone,
  //       ios: const IosSound(1023),
  //       looping: true,
  //       volume: 0.1,
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // static stopRingtone() {
  //   try {
  //     FlutterRingtonePlayer.stop();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // static Future<void> handleWebview(context, docUrl, appbarTitle) async {
  //   if (docUrl.contains(".pdf")) {
  //     // AppUtility.launchURL(docUrl);
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) =>
  //                 MyPdfViewer(docUrl: docUrl, appbarTitle: appbarTitle)));
  //   } else if (docUrl.contains(".doc")) {
  //     docUrl = "https://docs.google.com/viewer?url=$docUrl";
  //     AppUtility.launchURL(docUrl);
  //     return;
  //   } else {
  //     Get.to(() => WebViewExample(link: docUrl, appbarTitle: appbarTitle));
  //   }
  // }
}

class MySharedPreferences {
  Map<String, dynamic> convertToStringMap(Map<int, dynamic> someMap) {
    Map<String, dynamic> finalStrMap = <String, dynamic>{};
    someMap.forEach((key, value) {
      finalStrMap.putIfAbsent(key.toString(), () => value);
    });
    return finalStrMap;
  }

  Map<int, dynamic> convertToIntMap(Map<String, dynamic> someMap) {
    Map<int, dynamic> finalIntMap = <int, dynamic>{};
    someMap.forEach((key, value) {
      finalIntMap.putIfAbsent(int.parse(key), () => value);
    });
    return finalIntMap;
  }

  // Future<bool> setMap(String key, Map<int, dynamic> newMap) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     Map<int, dynamic> myIntMap = getMap(key) ?? {};
  //     Map<String, dynamic> myStringMap = convertToStringMap(myIntMap);
  //     Map<String, dynamic> myNewMap = convertToStringMap(newMap);

  //     // ignore: unnecessary_null_comparison
  //     if (myStringMap.isNotEmpty || myStringMap != null) {
  //       if (myStringMap.containsKey(myNewMap.keys.first)) {
  //         myStringMap.update(myNewMap.keys.first, (value) => myNewMap.values.first);
  //       } else {
  //         myStringMap.addAll(myNewMap);
  //       }
  //     } else {
  //       myStringMap.addAll(myNewMap);
  //     }

  //     String encodedMap = json.encode(myStringMap);
  //     print("setMap ========== $encodedMap");
  //     await prefs.setString(key, encodedMap);
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // Map<int, dynamic>? getMap(String key) {
  //   try {
  //     String? encodedMap = prefs!.getString(key) ?? '{}';
  //     Map<String, dynamic> decodedMap = json.decode(encodedMap);
  //     print("Map<int, dynamic> encodedMap ======== $encodedMap");
  //     print("Map<int, dynamic> decodedMap ======== $decodedMap");
  //     return convertToIntMap(decodedMap);
  //   } catch (e) {
  //     print("Map<int, dynamic> decodedMap ======== null");
  //     return null;
  //   }
  // }
}

class MyCustomFileFormat {
  final File? file;
  final bool isDoc;

  MyCustomFileFormat({this.file, this.isDoc = false});
}
