import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_text_field.dart';
import 'package:kakikeenam/app/modules/welcome/controllers/welcome_controller.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';
import 'package:kakikeenam/app/utils/validator.dart';

class ResetModal extends GetView<WelcomeController> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Container(
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
                    'Atur ulang password',
                    style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'inter'),
                  ),
                ),
                Form(
                  // key: controller.formKeyReset,
                  child: Column(
                    children: [
                      // Form
                      NewCustomTextField(controller: controller.resetEmailC, title: 'Email', hint: 'emailanda@email.com', validator: validateEmail, keyboardType: TextInputType.emailAddress,),
                      // Log in Button
                      Container(
                        margin: EdgeInsets.only(top: 32, bottom: 6),
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if(controller.formKeyReset.currentState?.validate() ?? false){
                              controller.resetPassword();
                              Get.back();
                            }
                          },
                          child: Text('Kirim ke email', style: TextStyle(color: AppColor.secondary, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'inter')),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            primary: AppColor.primarySoft,
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}