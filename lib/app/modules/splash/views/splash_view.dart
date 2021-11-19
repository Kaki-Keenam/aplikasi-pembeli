import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Obx(() => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Kaki Keenam",
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
            initialRoute: controller.isSkip
                ? controller.isAuth ||
                controller.user.value?.emailVerified == true ||
                snapshot.hasData
                ? Routes.PAGE_SWITCHER
                : Routes.WELCOME_PAGE
                : Routes.ONBOARDING,
            getPages: AppPages.routes,
          ));
        }
        return FutureBuilder(
          future: controller.initialize(),
          builder: (context, snapshot) => Splash(),
        );
      },
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.amber[600],
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/splash.png"),
                      fit: BoxFit.cover)),
            ),
            Center(
                child: Container(
                  width: Get.width * 0.45,
                  height: Get.width * 0.45,
                  child: Image.asset("assets/images/logo.png"),
                )),
          ],
        ),
      ),
    );
  }
}
