import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kakikeenam/app/data/services/location_service.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class SettingsController extends GetxController {
  final LocationService _locationService = Get.find<LocationService>();
  RxBool isRealtime = false.obs;

  @override
  void onReady() {
    isLocation();
    super.onReady();
  }

  Future<void> toggleLocation() async {
    await _locationService.toggleListening();
  }

  void isLocationEnable(bool status) {
    final box = GetStorage();
    box.write(Constants.LOCATION, status);
    isLocation();
  }

  void isLocation() {
    final box = GetStorage();
    var isEnabled = box.read(Constants.LOCATION);
    if(isEnabled != null){
      isRealtime.value = isEnabled;
    }
  }
}
