import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kakikeenam/app/data/services/location_service.dart';

class SettingsController extends GetxController {
  final LocationController _location = Get.find<LocationController>();
  RxBool isRealtime = false.obs;

  @override
  void onReady() {
    isLocation();
    super.onReady();
  }

  void isLocationEnable(bool status) {
    final box = GetStorage();
    box.write('location', status);

    isLocation();
  }

  void isLocation() {
    final box = GetStorage();
    var isEnabled = box.read('location');
      isRealtime.value = isEnabled;
  }
}
