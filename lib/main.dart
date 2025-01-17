
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/dependency_injection.dart';

import 'app/modules/components/widgets/splash_screen.dart';
import 'app/routes/app_pages.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then(
    (value) {
      runApp(MyApp());
    },
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
                initialBinding: DependencyInjection(),
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
                    ? authC.isAuth.value || authC.userAuth?.emailVerified == true ||
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
