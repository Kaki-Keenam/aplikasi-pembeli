import 'package:get/get.dart';

import 'package:kakikeenam/app/modules/change_profile/bindings/change_profile_binding.dart';
import 'package:kakikeenam/app/modules/change_profile/views/change_profile_view.dart';
import 'package:kakikeenam/app/modules/components/widgets/screens/page_switcher.dart';
import 'package:kakikeenam/app/modules/detailitem/bindings/detailitem_binding.dart';
import 'package:kakikeenam/app/modules/detailitem/views/detailitem_view.dart';
import 'package:kakikeenam/app/modules/forget_password/bindings/forget_password_binding.dart';
import 'package:kakikeenam/app/modules/forget_password/views/forget_password_view.dart';
import 'package:kakikeenam/app/modules/maps_location/bindings/maps_location_binding.dart';
import 'package:kakikeenam/app/modules/maps_location/views/maps_location_view.dart';
import 'package:kakikeenam/app/modules/near_vendor/bindings/near_vendor_binding.dart';
import 'package:kakikeenam/app/modules/near_vendor/views/near_vendor_view.dart';
import 'package:kakikeenam/app/modules/notification/bindings/notification_binding.dart';
import 'package:kakikeenam/app/modules/notification/views/notification_view.dart';
import 'package:kakikeenam/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:kakikeenam/app/modules/onboarding/views/onboarding_view.dart';
import 'package:kakikeenam/app/modules/profile/bindings/profile_binding.dart';
import 'package:kakikeenam/app/modules/profile/views/profile_view.dart';
import 'package:kakikeenam/app/modules/search/bindings/search_binding.dart';
import 'package:kakikeenam/app/modules/search/views/search_view.dart';
import 'package:kakikeenam/app/modules/welcome/welcome_page.dart';

import '../../app_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.DETAILITEM,
      page: () => DetailItemView(),
      binding: DetailitemBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(name: _Paths.PAGE_SWITCHER, page: () => PageSwitcher(), bindings: [
      AppBinding(),
    ]),
    GetPage(name: _Paths.WELCOME_PAGE, page: () => WelcomePage()),
    GetPage(
      name: _Paths.MAPS_LOCATION,
      page: () => MapsLocationView(),
      binding: MapsLocationBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PROFILE,
      page: () => ChangeProfileView(),
      binding: ChangeProfileBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.NEAR_VENDOR,
      page: () => NearVendorView(),
      binding: NearVendorBinding(),
    ),
  ];
}
