import 'package:get/get.dart';

import '../controllers/near_vendor_controller.dart';

class NearVendorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NearVendorController>(
      () => NearVendorController(),
    );
  }
}
