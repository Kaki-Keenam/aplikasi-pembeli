import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_button.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_text_field.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  final authC = Get.find<AuthController>();
  final args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.emailC.text = args.email;
    controller.nameC.text = args.name.toString();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber[600],
          title: Text(
            'Change Profile',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                await controller
                    .uploadImage(authC.user.value.uid)
                    .then((value) => {
                          if (value != "") {authC.updatePhoto(value)}
                        });
                authC.changeProfile(
                  controller.nameC.text,
                );
              },
              icon: Icon(Icons.save),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GetBuilder<ChangeProfileController>(
                  builder: (c) => Column(
                    children: [
                      AvatarGlow(
                        endRadius: 75,
                        glowColor: Colors.black,
                        duration: Duration(seconds: 2),
                        child: Container(
                          margin: EdgeInsets.all(15),
                          width: 120,
                          height: 120,
                          child: controller.pickerImage != null
                              ? Stack(
                                  children: [
                                    Center(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: FileImage(
                                                File(c.pickerImage!.path),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: -5,
                                      child: IconButton(
                                        onPressed: () =>
                                            controller.resetImage(),
                                        icon: Icon(Icons.delete),
                                      ),
                                    ),
                                  ],
                                )
                              : Obx(
                                  () => Stack(
                                    children: [
                                      Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(200),
                                          child: authC.user.value.photoUrl ==
                                                  null
                                              ? Image.asset(
                                                  Constants.PROFILE,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  authC.user.value.photoUrl ??
                                                      "",
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: -5,
                                        child: IconButton(
                                          onPressed: () =>
                                              controller.selectedImage(),
                                          icon: Icon(Icons.camera_alt),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                NewCustomTextField(
                  hint: "Alamat Email",
                  controller: controller.emailC,
                  readOnly: true,
                  backgroundColour: Colors.grey[300],
                  title: 'Alamat Email',
                ),
                SizedBox(height: 10),
                NewCustomTextField(
                  title: "Nama",
                  hint: "Name",
                  controller: controller.nameC,
                ),
                SizedBox(height: 40),
                Container(
                  margin: EdgeInsets.only(
                    bottom: context.mediaQueryPadding.bottom,
                  ),
                  width: Get.width,
                  child: Obx(
                    () => CustomButton(
                      text: "UPDATE",
                      backgroundColor: Colors.amber[600],
                      textColor: Colors.white,
                      loading: authC.loading.value
                          ? controller.loading.value = true
                          : false,
                      func: () async {
                        authC.changeProfile(
                          controller.nameC.text,
                        );
                        await controller.uploadImage(authC.user.value.uid).then(
                              (value) =>
                                  {if (value != "") authC.updatePhoto(value)},
                            );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
