import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/strings.dart';


class OnboardingView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: Get.width * 0.2,
          height: Get.width * 0.2,
          child: Image.asset(Strings.logo),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: Strings.title1,
            body: Strings.content1,
            decoration: PageDecoration(
              titleTextStyle: TextStyle(fontFamily: 'inter', fontSize: 20, fontWeight: FontWeight.bold),
              bodyTextStyle: TextStyle(fontFamily: 'inter', fontSize: 16),
            ),
            image: Container(
              width: Get.width,
              height: Get.width,
              decoration: BoxDecoration(
                color: Colors.amber[600],
              ),
              child: Container(
                child: Center(
                  child: Image.asset(
                    Strings.board1,
                    width: Get.width * 0.5,
                  ),
                ),
              ),
            ),
          ),
          PageViewModel(
            title: Strings.title2,
            body: Strings.content2,
            decoration: PageDecoration(
              titleTextStyle: TextStyle(fontFamily: 'inter', fontSize: 20, fontWeight: FontWeight.bold),
              bodyTextStyle: TextStyle(fontFamily: 'inter', fontSize: 16),
            ),
            image: Container(
              width: Get.width,
              height: Get.width,
              decoration: BoxDecoration(
                  color: Colors.amber[600],
                 ),
              child: Container(
                child: Center(
                  child: Image.asset(
                    Strings.board2,
                    width: Get.width * 0.5,
                  ),
                ),
              ),
            ),
          ),
          PageViewModel(
            title: Strings.title3,
            body: Strings.content3,
            decoration: PageDecoration(
              titleTextStyle: TextStyle(fontFamily: 'inter', fontSize: 20, fontWeight: FontWeight.bold),
              bodyTextStyle: TextStyle(fontFamily: 'inter', fontSize: 16),
            ),
            image: Container(
              width: Get.width,
              height: Get.width,
              decoration: BoxDecoration(
                  color: Colors.amber[600],
                  borderRadius: BorderRadius.only(
                  )),
              child: Container(
                child: Center(
                  child: Image.asset(
                    Strings.board3,
                    width: Get.width * 0.5,
                  ),
                ),
              ),
            ),
          )
        ],
        onDone: () => Get.offAllNamed(Routes.WELCOME_PAGE),
        showSkipButton: true,
        skip: Text(
          Strings.skip,
          style: TextStyle(color: Colors.black54),
        ),
        next: Text(
          Strings.next,
          style: TextStyle(color: Colors.black54),
        ),
        done: Text(
          Strings.done,
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
