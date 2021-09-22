import 'package:get/get.dart';

import '../controllers/detailitem_controller.dart';

class DetailitemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailItemController>(
      () => DetailItemController(),
    );
  }
}
