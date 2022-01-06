import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/welcome/controllers/welcome_controller.dart';
import 'package:kakikeenam/app/modules/welcome/widgets/login_modal_view.dart';
import 'package:kakikeenam/app/modules/welcome/widgets/register_modal_view.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';
import 'package:kakikeenam/app/utils/strings.dart';

class WelcomePage extends GetView<WelcomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: Colors.amber[600]),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 85 / 100,
                  decoration: BoxDecoration(gradient: AppColor.linearBlackBottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Get.width * 0.5,
                        height: Get.width * 0.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/images/logo.png')),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Get Started Button
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: ElevatedButton(
                              child: Text('Daftar', style: TextStyle(color: AppColor.secondary, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'inter')),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return RegisterModal();
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                primary: AppColor.primarySoft,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Log in Button
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: OutlinedButton(
                              child: Text(Strings.login, style: TextStyle(color: AppColor.secondary, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'inter')),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return LoginModal();
                                  },
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                side: BorderSide(color: AppColor.secondary.withOpacity(0.5), width: 1),
                                primary: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: ElevatedButton(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(width: 45, height: 45, child: Image.asset(Strings.google)),
                                    Text(Strings.login_google, style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'inter')),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                controller.loginGoogle();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                primary: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            margin: EdgeInsets.only(top: 32),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'By joining Kaki Keenam, you agree to our ',
                                style: TextStyle(color: Colors.white.withOpacity(0.6), height: 150 / 100),
                                children: [
                                  TextSpan(
                                    text: 'Terms of service ',
                                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w700, height: 150 / 100),
                                  ),
                                  TextSpan(
                                    text: 'and ',
                                    style: TextStyle(color: Colors.white.withOpacity(0.6), height: 150 / 100),
                                  ),
                                  TextSpan(
                                    text: 'Privacy policy.',
                                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w700, height: 150 / 100),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
