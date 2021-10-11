import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_button.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_text_field.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/strings.dart';

import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
      ),
      body: ListView(
        children: [
          Stack(children: [
            Container(
              height: Get.height * 0.2,
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.amber[600],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  Strings.forget_password,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Center(
              child: Container(
                width: Get.width * 0.9,
                height: Get.height * 0.4,
                margin: EdgeInsets.only(top: Get.height * 0.1),
                child: Card(
                  elevation: 2,
                  shadowColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            Strings.your_email,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        NewCustomTextField(
                          title: Strings.email,
                          controller: controller.emailC,
                          hint: Strings.email,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          text: Strings.change_pass,
                          backgroundColor: Colors.amber[600],
                          textColor: Colors.white,
                          func: () => authC.resetPassword(controller.emailC.text),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Strings.have_account),
                    TextButton(
                      onPressed: () => Get.offAllNamed(Routes.WELCOME_PAGE),
                      child: Text(Strings.login_now),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
