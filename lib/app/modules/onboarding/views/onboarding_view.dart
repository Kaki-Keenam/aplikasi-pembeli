import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: Get.width * 0.2,
          height: Get.width * 0.2,
          child: Image.asset("assets/images/logo.png"),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Temukan pedagang disekitarmu",
            body: "Kamu hanya perlu memanggil pedagang disekelilingmu.",
            image: Container(
              width: Get.width,
              height: Get.width,
              decoration: BoxDecoration(
                color: Colors.amber[600],
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Container(
                child: Center(
                  child: Image.asset(
                    "assets/images/board1.png",
                    width: Get.width * 0.5,
                  ),
                ),
              ),
            ),
          ),
          PageViewModel(
            title: "Temukan jajanan enak disekitarmu",
            body: "Biarkan pedagang keliling menghampirimu tanpa mencarinya.",
            image: Container(
              width: Get.width,
              height: Get.width,
              decoration: BoxDecoration(
                  color: Colors.amber[600],
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )),
              child: Container(
                child: Center(
                  child: Image.asset(
                    "assets/images/board2.png",
                    width: Get.width * 0.5,
                  ),
                ),
              ),
            ),
          ),
          PageViewModel(
            title: "Jangkau pedangan dengan sekali klik",
            body: "Kamu hanya perlu memanggil pedangan lewat notifikasi.",
            image: Container(
              width: Get.width,
              height: Get.width,
              decoration: BoxDecoration(
                  color: Colors.amber[600],
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )),
              child: Container(
                child: Center(
                  child: Image.asset(
                    "assets/images/board3.png",
                    width: Get.width * 0.5,
                  ),
                ),
              ),
            ),
          )
        ],
        onDone: () => Get.offAllNamed(Routes.LOGIN),
        showSkipButton: true,
        skip: Text(
          "Skip",
          style: TextStyle(color: Colors.black54),
        ),
        next: Text(
          "Next",
          style: TextStyle(color: Colors.black54),
        ),
        done: const Text(
          "Done",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Colors.amber,
          color: Colors.amberAccent,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }
}
