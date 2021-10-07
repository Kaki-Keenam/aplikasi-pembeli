import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';

import 'app/modules/components/widgets/splash_screen.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then(
    (value) => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Obx(() => GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: "Kakikeenam",
                theme: ThemeData(
                  colorScheme: ColorScheme.light(primary: Color(0xFFFFB300)),
                  primaryIconTheme: IconThemeData(color: Colors.white),
                  scaffoldBackgroundColor: Colors.white,
                  primaryTextTheme: TextTheme(
                    headline6: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                initialRoute: authC.isSkipIntro.value
                    ? authC.isAuth.value ||
                            snapshot.hasData &&
                                authC.connectC.connectionStatus !=
                                    ConnectivityResult.none
                        ? Routes.PAGE_SWITCHER
                        : Routes.WELCOME_PAGE
                    : Routes.ONBOARDING,
                getPages: AppPages.routes,
              ));
        }
        return FutureBuilder(
          future: authC.firsInitialized(),
          builder: (context, snapshot) => SplashScreen(),
        );
      },
    );
  }
}
