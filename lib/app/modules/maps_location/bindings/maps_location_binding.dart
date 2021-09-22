import 'package:get/get.dart';

import '../controllers/maps_location_controller.dart';

class MapsLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapsLocationController>(
      () => MapsLocationController(),
    );
  }
}
