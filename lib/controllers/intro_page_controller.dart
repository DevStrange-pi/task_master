import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class IntroPageController extends GetxController{
  SharedPreferences? prefs;
  RxString flavor = "".obs;

  @override
  void onInit() {
    initAsync();
    super.onInit();
  }
  void initAsync() async{
    prefs = await SharedPreferences.getInstance();
    flavor.value = prefs!.getString('FLAVOR')!; 
  }
}
