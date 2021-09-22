import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/favorite/controllers/favorite_controller.dart';
import 'package:kakikeenam/app/modules/home/controllers/home_controller.dart';
import 'package:kakikeenam/app/modules/notification/controllers/notification_controller.dart';
import 'package:kakikeenam/app/modules/settings/controllers/settings_controller.dart';

import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<FavoriteController>(
      () => FavoriteController(),
    );
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}
