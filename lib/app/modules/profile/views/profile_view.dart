import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    print(authC.user.value.email);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Profile"),
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                Obx(
                      () =>
                      AvatarGlow(
                        endRadius: 110,
                        glowColor: Colors.black,
                        duration: Duration(seconds: 2),
                        child: Container(
                          margin: EdgeInsets.all(15),
                          width: 175,
                          height: 175,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: authC.user.value.photoUrl == null
                                ? Image.asset(
                              "assets/images/person.png",
                              fit: BoxFit.cover,
                            )
                                : Image.network(
                              authC.user.value.photoUrl ?? "",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                ),
                Obx(
                      () =>
                      Text(
                        "${authC.user.value.name ?? ""}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                ),
                Text(
                  "${authC.user.value.email ?? ""}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.note_add_outlined),
                    title: Text(
                      "Update Realtime",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () => Get.toNamed(Routes.CHANGE_PROFILE, arguments: authC.userValue,),
                    leading: Icon(Icons.person),
                    title: Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () {
                      Get.defaultDialog(
                        title: "Logout",
                        middleText: "Apakah anda yakin ingin logout?",
                        onConfirm: () {
                          authC.logout();
                        },
                        textConfirm: "Ok",
                        textCancel: "Batal",
                      );
                    },
                    leading: Icon(Icons.exit_to_app_rounded),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin:
            EdgeInsets.only(bottom: context.mediaQueryPadding.bottom + 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Kaki Keenam",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "v.1.0",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
