
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_button.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_textfield.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
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
                  "Kaki Keenam",
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
                height: Get.height * 0.5,
                margin: EdgeInsets.only(top: Get.height * 0.1),
                child: Card(
                  elevation: 2,
                  shadowColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 28),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: controller.emailC,
                            hintText: "Alamat Email",
                            prefixIcon: Icon(Icons.email),
                            validator: (value){
                              if (value == null || value.isEmpty) {
                                return "Isi email anda !";
                              }
                              if (!EmailValidator.validate(value)) {
                                return "Email tidak valid!";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Obx(
                            () => CustomTextField(
                              controller: controller.passwordC,
                              hintText: "Password",
                              validator: (value){
                                if (value == null || value.isEmpty) {
                                  return "Isi password anda !";
                                }
                              },
                              obscureText: !controller.isShowPassword.value,
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: controller.isShowPassword.value
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                      ),
                                      onPressed: () =>
                                          controller.isShowPassword.toggle(),
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () =>
                                          controller.isShowPassword.toggle(),
                                    ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  Get.toNamed(Routes.FORGET_PASSWORD),
                              child: Text("Lupa Password ?"),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Obx(() => CustomButton(
                              text: "Login",
                              backgroundColor: Colors.amber[600],
                              textColor: Colors.white,
                              loading: authC.loading.value,
                              func: () {
                                if (controller.formKey.currentState!.validate()) {
                                  authC.loading.value
                                      ? null : authC.loginAuth(
                                    controller.emailC.text,
                                    controller.passwordC.text,
                                  );
                                }
                              }
                            ),
                          ),
                        ],
                      ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: CustomButton(
                    text: "Login dengan Google",
                    icon: Image.asset("assets/images/google.png"),
                    backgroundColor: Colors.white,
                    textColor: Colors.black54,
                    func: () => authC.loginWithGoogle(),
                    isIconShow: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun ? '),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.REGISTER),
                      child: Text('Daftar Sekarang'),
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
