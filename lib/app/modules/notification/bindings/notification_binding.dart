import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/notification/controllers/notification_controller.dart';
class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
    );
  }
}
