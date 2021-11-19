import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kakikeenam/app/modules/components/widgets/user_info_tile.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';
import 'package:kakikeenam/app/utils/strings.dart';
import 'package:kakikeenam/app/utils/validator.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(Strings.profile_title,
            style: TextStyle(
                fontFamily: 'inter',
                fontWeight: FontWeight.w400,
                fontSize: 16)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Logout Akun",
                barrierDismissible: false,
                content: Text("Apakah anda yakin ingin logout ?"),
                onConfirm: () {
                  controller.logout();
                  Get.back();
                },
                textConfirm: "Ya",
                textCancel: "Tidak",
              );
            },
            child: Icon(Icons.exit_to_app_rounded),
            style: TextButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100))),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Profile Picture Wrapper
          GetBuilder<ProfileController>(builder: (logic) {
            return Container(
              color: AppColor.primary,
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    margin: EdgeInsets.only(bottom: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: controller.pickerImage != null
                          ? Image(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(logic.pickerImage!.path),
                              ),
                            )
                          : Obx(
                              () => controller.user.photoUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: '${controller.user.photoUrl}',
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          Transform.scale(
                                        scale: 0.5,
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : Image.asset(Strings.avatar),
                            ),
                    ),
                  ),
                  (controller.pickerImage != null)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  controller.resetImage();
                                },
                                child: Text(Strings.cancel)),
                            ElevatedButton(
                                onPressed: () async {
                                  await controller
                                      .uploadImage(controller.user.uid)
                                      .then(
                                        (value) => {
                                          if (value != "")
                                            controller.updatePhoto(value)
                                        },
                                      );
                                },
                                child: Text(Strings.save))
                          ],
                        )
                      : GestureDetector(
                          onTap: () => controller.selectedImage(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(Strings.change_pic,
                                  style: TextStyle(
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              SizedBox(width: 8),
                              SvgPicture.asset(Strings.camera,
                                  color: Colors.white),
                            ],
                          ),
                        )
                ],
              ),
            );
          }),
          // Section 2 - User Info Wrapper
          Container(
            margin: EdgeInsets.only(top: 24),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return UserInfoTile(
                    margin: EdgeInsets.only(bottom: 16),
                    label: Strings.email,
                    value: '${controller.user.email}',
                  );
                }),
                Obx(() {
                  return UserInfoTile(
                    margin: EdgeInsets.only(bottom: 16),
                    label: Strings.name,
                    value: '${controller.user.name}',
                    button: TextButton(
                      onPressed: () {
                        Get.dialog(Center(
                          child: Material(
                            color: Colors.white,
                            child: Container(
                              height: 160,
                              width: Get.width * 0.9,
                              padding: EdgeInsets.all(10),
                              child: Form(
                                key: controller.formKeyName,
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(Strings.change_name),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: controller.nameEditC,
                                      validator: validateName,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () => Get.back(),
                                              child: Text(Strings.cancel)),
                                          ElevatedButton(
                                              onPressed: () {
                                                if(controller.formKeyName.currentState?.validate() ?? false){
                                                  controller.editName(
                                                      controller.nameEditC.text);
                                                  Get.back();
                                                }
                                              },
                                              child: Text(Strings.save),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                      },
                      child: Text(Strings.edit),
                    ),
                  );
                }),
                UserInfoTile(
                  margin: EdgeInsets.only(bottom: 16),
                  label: Strings.last_login,
                  value: '${controller.user.lastSignTime != null ? DateFormat('EEE, d MMM yyyy HH:mm:ss').format(
                      DateTime.parse(controller.user.lastSignTime!),
                    ) : DateFormat('EEE, d MMM yyyy HH:mm:ss').format(DateTime.now())}',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
