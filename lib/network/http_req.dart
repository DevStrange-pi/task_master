import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utilities/utilities.dart';


class HttpReq {
  static Future<http.Response?> postApi({String? apiUrl, var body, var headers}) async {
    try {
      // ***APP_LOG***
      if (headers == null || (headers.length == 0)) {
        headers = {"Content-Type": "application/json", "Accept": "application/json"};
      }
      // AppLog.basicLog(pageName: "http_req", methodName: "postApi", msg: "Called postApi");
      print("AppUrl -> $apiUrl , Body $body");
      body = json.encode(body);
      http.Response response =
          await http.post(Uri.parse(apiUrl!), headers: headers, body: body).timeout(const Duration(seconds: 50));
      print("Response code ${response.statusCode} , response ${response.body}");
      return response;
    } catch (e) {
      // ***APP_LOG***

      myBotToast(e.toString());
      // AppLog.basicLog(pageName: "http_req", methodName: "postApi", msg: e.toString());
    }
    return null;
  }
  static Future<http.Response?> patchApi({String? apiUrl, var body, var headers}) async {
    try {
      // ***APP_LOG***
      if (headers == null || (headers.length == 0)) {
        headers = {"Content-Type": "application/json", "Accept": "application/json"};
      }
      // AppLog.basicLog(pageName: "http_req", methodName: "postApi", msg: "Called postApi");
      print("AppUrl -> $apiUrl , Body $body");
      body = json.encode(body);
      http.Response response =
          await http.patch(Uri.parse(apiUrl!), headers: headers, body: body).timeout(const Duration(seconds: 50));
      print("Response code ${response.statusCode} , response ${response.body}");
      return response;
    } catch (e) {
      // ***APP_LOG***

      myBotToast(e.toString());
      // AppLog.basicLog(pageName: "http_req", methodName: "postApi", msg: e.toString());
    }
    return null;
  }

  static Future<http.Response?> deleteApi({String? apiUrl, var headers}) async {
    try {
      // ***APP_LOG***
      if (headers == null || (headers.length == 0)) {
        headers = {"Content-Type": "application/json", "Accept": "application/json"};
      }
      print("AppUrl -> $apiUrl , Headers $headers");
      http.Response response = await http.delete(Uri.parse(apiUrl!), headers: headers).timeout(const Duration(seconds: 50));
      print("Response code ${response.statusCode} , response ${response.body}");
      return response;
    } catch (e) {
      myBotToast(e.toString());
    }
    return null;
  }

  static Future<http.Response?> getApi({String? apiUrl, var headers}) async {
    try {
      // ***APP_LOG***
      // AppLog.basicLog(pageName: "http_req", methodName: "getApi", msg: "Called getApi");
      if (headers == null || (headers.length == 0)) {
        headers = {"Content-Type": "application/json", "Accept": "application/json"};
      }
      print("AppUrl -> $apiUrl , Body $headers");
      http.Response response = await http.get(Uri.parse(apiUrl!), headers: headers);
      print("Response code ${response.statusCode} , response ${response.body}");
      return response;
    } catch (e) {
      // ***APP_LOG***
      // AppLog.basicLog(pageName: "http_req", methodName: "getApi", msg: e.toString());
    }
    return null;
  }
}
