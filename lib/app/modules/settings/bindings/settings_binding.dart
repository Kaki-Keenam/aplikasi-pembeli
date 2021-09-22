import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/onboarding/controllers/onboarding_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
    );
  }
}
