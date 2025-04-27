import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_master/models/register_employee_response_model.dart';

import '../constants/app_url.dart';
import '../network/http_req.dart';
import '../utilities/circular_loader.dart';
import '../utilities/utilities.dart';

class AddProfileController extends GetxController {
  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Rx<XFile?>? pickedFile;
  Rx<CroppedFile?>? croppedFile;

  Future<void> cropImage() async {
    if (pickedFile != null) {
      final croppedFileTemp = await ImageCropper().cropImage(
        sourcePath: pickedFile!.value!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
        ],
      );
      if (croppedFile != null) {
        croppedFile!.value = croppedFileTemp;
      }
    }
  }

  Future<void> uploadImage() async {
    final pickedFileTemp =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pickedFile!.value = pickedFileTemp;
    }
  }

  void clear() {
    pickedFile!.value = null;
    croppedFile!.value = null;
  }

  Future<bool> addProfile(String name, String email, String contactNumber,
      String designation, String employeeId,String username,String password) async {
    circularLoader.showCircularLoader();
    // String token = prefs!.getString(SpString.token)!;
    try {
      var headers = {
        // "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var resp = await HttpReq.postApi(
          apiUrl: AppUrl().register,
          headers: headers,
          body: {
            "name": name,
            "email": email,
            "contact_number": contactNumber,
            "designation": designation,
            "employee_id": employeeId,
            "username": username,
            "password": password,
            "role": "employee"
          });
      var respBody = json.decode(resp!.body);
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        RegisterEmployeeResponseModel registerEmployeeResponseModel =
            RegisterEmployeeResponseModel.fromJson(respBody);
        myBotToast(registerEmployeeResponseModel.message ?? "");
        Get.back(result: true);
        circularLoader.hideCircularLoader();
        return true;
      } else {
        circularLoader.hideCircularLoader();
        myBotToast(respBody["message"]);
        return false;
      }
    } catch (e) {
      circularLoader.hideCircularLoader();
      return false;
    }
  }
  void onSubmitPressed() async {
    if (nameController.text.isEmpty) {
      myBotToast("Please enter a Name");
      return;
    }
    if (emailController.text.isEmpty) {
      myBotToast("Please enter an Email");
      return;
    }
    if (mobileController.text.isEmpty) {
      myBotToast("Please enter a Mobile Number");
      return;
    }
    if (designationController.text.isEmpty) {
      myBotToast("Please enter a Designation");
      return;
    }
    if (employeeIdController.text.isEmpty) {
      myBotToast("Please enter an Employee ID");
      return;
    }
    if (usernameController.text.isEmpty) {
      myBotToast("Please enter a Username");
      return;
    }
    if (passwordController.text.isEmpty) {
      myBotToast("Please enter a Password");
      return;
    }
    // if (pickedFile == null) {
    //   myBotToast("Please select a Profile Image");
    //   return;
    // }
    
    await addProfile(
        nameController.text,
        emailController.text,
        mobileController.text,
        designationController.text,
        employeeIdController.text,
        usernameController.text,
        passwordController.text);
  }
}
