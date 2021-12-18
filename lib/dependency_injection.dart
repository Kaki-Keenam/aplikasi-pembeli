
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/provider/auth_remote.dart';
import 'package:kakikeenam/app/data/provider/db_remote.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/data/services/helper_controller.dart';
import 'package:kakikeenam/app/data/services/location_service.dart';
import 'package:kakikeenam/app/data/services/messaging/fcm.dart';
import 'package:kakikeenam/app/modules/chat/controllers/chat_controller.dart';
import 'package:kakikeenam/app/modules/favorite/controllers/favorite_controller.dart';
import 'package:kakikeenam/app/modules/home/controllers/home_controller.dart';
import 'package:kakikeenam/app/modules/settings/controllers/settings_controller.dart';
import 'package:kakikeenam/app/modules/splash/controllers/splash_controller.dart';

import 'app/modules/trans_history/controllers/trans_history_controller.dart';


class DependencyInjection {
  static void init() {

    Get.lazyPut<AuthRemote>(() => AuthRemote(), fenix: true);
    Get.lazyPut<RepositoryRemote>(() => RepositoryRemote(), fenix: true);
    Get.lazyPut<DbRemote>(() => DbRemote(), fenix: true);

    Get.lazyPut<LocationService>(() => LocationService(), fenix: true);
    Get.lazyPut<HelperController>(() => HelperController(), fenix: true);
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<Fcm>(() => Fcm(), fenix: true);

    Get.lazyPut<TransHistoryController>(
            () => TransHistoryController(),
        fenix: true
    );
    Get.lazyPut<HomeController>(
          () => HomeController(),
      fenix: true
    );
    Get.lazyPut<FavoriteController>(
          () => FavoriteController(),
      fenix: true
    );
    Get.lazyPut<SettingsController>(
          () => SettingsController(),
      fenix: true
    );
    Get.lazyPut<ChatController>(
            () => ChatController(),
        fenix: true
    );
  }
}
