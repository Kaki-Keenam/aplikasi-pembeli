import 'package:get/get.dart';

import 'package:kakikeenam/app/modules/components/widgets/screens/page_switcher.dart';
import 'package:kakikeenam/app/modules/detailitem/bindings/detailitem_binding.dart';
import 'package:kakikeenam/app/modules/detailitem/views/detailitem_view.dart';
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
import 'package:kakikeenam/app/modules/splash/bindings/splash_binding.dart';
import 'package:kakikeenam/app/modules/splash/views/splash_view.dart';
import 'package:kakikeenam/app/modules/vendor_detail/bindings/vendor_detail_binding.dart';
import 'package:kakikeenam/app/modules/vendor_detail/views/vendor_detail_view.dart';
import 'package:kakikeenam/app/modules/welcome/bindings/welcome_binding.dart';
import 'package:kakikeenam/app/modules/welcome/welcome_page.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

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
        name: _Paths.PAGE_SWITCHER,
        page: () => PageSwitcher(),),
    GetPage(name: _Paths.WELCOME_PAGE,
        page: () => WelcomePage(),
        binding: WelcomeBinding()),
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
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.NEAR_VENDOR,
      page: () => NearVendorView(),
      binding: NearVendorBinding(),
    ),
    GetPage(
      name: _Paths.VENDOR_DETAIL,
      page: () => VendorDetailView(),
      binding: VendorDetailBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
