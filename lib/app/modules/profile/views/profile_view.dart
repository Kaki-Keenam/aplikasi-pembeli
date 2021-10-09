import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/modules/components/widgets/notify_dialogs.dart';
import 'package:kakikeenam/app/modules/components/widgets/user_info_tile.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: true,
        title: Text('My Profile',
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
              NotifyDialogs().logoutDialog(func: () {
                authC.logout();
                Get.back();
              });
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
                      child: controller.pickerImage != null ?
                      Image(fit: BoxFit.cover, image: FileImage(
                        File(logic.pickerImage!.path),
                      ),)
                     :
                      Obx(()=> authC.userValue.photoUrl != null
                            ? CachedNetworkImage(
                          imageUrl: '${authC.userValue.photoUrl}',
                          fit: BoxFit.fill,
                          placeholder: (context, url) =>
                              Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(),
                              ),
                        )
                            : Image.asset('assets/images/person.png'),
                      ),
                    ),
                  ),
                  (controller.pickerImage != null) ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: (){controller.resetImage();}, child: Text('Cancel')),
                      ElevatedButton(onPressed: () async {await controller.uploadImage(authC.user.value.uid).then(
                            (value) =>
                        {if (value != "") authC.updatePhoto(value)},
                      );}, child: Text('Simpan'))
                    ],
                  ) : GestureDetector(
                    onTap: () => controller.selectedImage(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Change Profile Picture',
                            style: TextStyle(
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        SizedBox(width: 8),
                        SvgPicture.asset('assets/icons/camera.svg',
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
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfoTile(
                  margin: EdgeInsets.only(bottom: 16),
                  label: 'Email',
                  value: '${authC.userValue.email}',
                ),
                UserInfoTile(
                  margin: EdgeInsets.only(bottom: 16),
                  label: 'Full Name',
                  value: '${authC.userValue.name}',
                  button: TextButton(onPressed: () {
                    Get.dialog(
                        Center(
                          child: Material(
                            color: Colors.white,
                            child: Container(
                              height: 150,
                              width: Get.width * 0.9,
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Center(child: Text('Ganti Nama'),),
                                  SizedBox(height: 10,),
                                  TextField(
                                    controller: controller.nameEditC,
                                  ),
                                  SizedBox(height: 10,),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, children: [
                                      ElevatedButton(
                                          onPressed: () => Get.back(),
                                          child: Text("Cancel")),
                                      ElevatedButton(onPressed: () {
                                        authC.editName(
                                            controller.nameEditC.text);
                                        Get.back();
                                      }, child: Text("Simpan"))
                                    ],),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                    );
                  },
                    child: Text('Edit'),),
                ),
                UserInfoTile(
                  margin: EdgeInsets.only(bottom: 16),
                  label: 'Terakhir Login',
                  value: '${DateFormat('EEE, d MMM yyyy HH:mm:ss').format(
                    DateTime.parse(authC.userValue.lastSignTime ?? ""),
                  )}',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
