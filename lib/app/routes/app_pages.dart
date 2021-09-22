import 'package:get/get.dart';

import 'package:kakikeenam/app/modules/change_profile/bindings/change_profile_binding.dart';
import 'package:kakikeenam/app/modules/change_profile/views/change_profile_view.dart';
import 'package:kakikeenam/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:kakikeenam/app/modules/dashboard/views/dashboard_view.dart';
import 'package:kakikeenam/app/modules/detailitem/bindings/detailitem_binding.dart';
import 'package:kakikeenam/app/modules/detailitem/views/detailitem_view.dart';
import 'package:kakikeenam/app/modules/favorite/bindings/favorite_binding.dart';
import 'package:kakikeenam/app/modules/favorite/views/favorite_view.dart';
import 'package:kakikeenam/app/modules/forget_password/bindings/forget_password_binding.dart';
import 'package:kakikeenam/app/modules/forget_password/views/forget_password_view.dart';
import 'package:kakikeenam/app/modules/home/bindings/home_binding.dart';
import 'package:kakikeenam/app/modules/home/views/home_view.dart';
import 'package:kakikeenam/app/modules/login/bindings/login_binding.dart';
import 'package:kakikeenam/app/modules/login/views/login_view.dart';
import 'package:kakikeenam/app/modules/maps_location/bindings/maps_location_binding.dart';
import 'package:kakikeenam/app/modules/maps_location/views/maps_location_view.dart';
import 'package:kakikeenam/app/modules/notification/bindings/notification_binding.dart';
import 'package:kakikeenam/app/modules/notification/views/notification_view.dart';
import 'package:kakikeenam/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:kakikeenam/app/modules/onboarding/views/onboarding_view.dart';
import 'package:kakikeenam/app/modules/profile/bindings/profile_binding.dart';
import 'package:kakikeenam/app/modules/profile/views/profile_view.dart';
import 'package:kakikeenam/app/modules/register/bindings/register_binding.dart';
import 'package:kakikeenam/app/modules/register/views/register_view.dart';
import 'package:kakikeenam/app/modules/settings/bindings/settings_binding.dart';
import 'package:kakikeenam/app/modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
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
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.FAVORITE,
      page: () => FavoriteView(),
      binding: FavoriteBinding(),
    ),
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
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
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
  ];
}
