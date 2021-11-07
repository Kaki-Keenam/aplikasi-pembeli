import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_text_field.dart';
import 'package:kakikeenam/app/modules/welcome/controllers/welcome_controller.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';

import 'login_modal_view.dart';

class RegisterModal extends GetView<WelcomeController> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 85 / 100,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            physics: BouncingScrollPhysics(),
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 35 / 100,
                  margin: EdgeInsets.only(bottom: 20),
                  height: 6,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
                ),
              ),
              // header
              Container(
                margin: EdgeInsets.only(bottom: 24),
                child: Text(
                  'Daftar',
                  style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'inter'),
                ),
              ),
              // Form
              NewCustomTextField(controller: controller.emailC, title: 'Email', hint: 'emailanda@email.com'),
              NewCustomTextField(controller: controller.nameC, title: 'Nama Lengkap', hint: 'Nama Lengkap Anda', margin: EdgeInsets.only(top: 16)),
              NewCustomTextField(controller: controller.passC, title: 'Password', hint: '**********', obsecureText: true, margin: EdgeInsets.only(top: 16)),
              NewCustomTextField(title: 'Konfirmasi Password', hint: '**********', obsecureText: true, margin: EdgeInsets.only(top: 16)),
              // Register Button
              Container(
                margin: EdgeInsets.only(top: 32, bottom: 6),
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: ElevatedButton(
                    onPressed: () {
                      controller.register();
                      Get.back();
                    },
                    child: Text('Daftar', style: TextStyle(color: AppColor.secondary, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'inter')),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      primary: AppColor.primarySoft,
                    ),
                  ),
              ),
              // Login textbutton
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'Sudah punya akun? ',
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                          style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'inter',
                          ),
                          text: 'Log in')
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
