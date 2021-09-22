import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/favorite/controllers/favorite_controller.dart';


class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoriteController>(
      () => FavoriteController(),
    );
  }
}
