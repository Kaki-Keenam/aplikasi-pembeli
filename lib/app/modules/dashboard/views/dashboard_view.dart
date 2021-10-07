import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/favorite/views/favorite_view.dart';
import 'package:kakikeenam/app/modules/home/views/home_view.dart';
import 'package:kakikeenam/app/modules/settings/views/settings_view.dart';
import 'package:kakikeenam/app/modules/trans_history/views/trans_history_view.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  final iconList = <IconData>[
    Icons.home,
    Icons.favorite,
    Icons.history,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Obx(
      () => Scaffold(
        floatingActionButton: keyboardIsOpened
            ? Visibility(
                visible: false,
                child: FloatingActionButton(
                  onPressed: () {},
                ),
              )
            : FloatingActionButton(
                onPressed: () {
                  controller.loading.value = true;
                  Future.delayed(Duration(seconds: 2), ()
                      {
                        controller.loading.value = false;
                        Get.toNamed(Routes.MAPS_LOCATION);
                      }
                  );

                },
                backgroundColor: Colors.amber[600],
                child: controller.loading.value
                    ? CircularProgressIndicator(color: Colors.white,)
                    : Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: iconList,
          inactiveColor: Colors.black87,
          activeColor: Colors.amber[600],
          activeIndex: controller.getIndex(),
          gapLocation: GapLocation.center,
          leftCornerRadius: 10,
          rightCornerRadius: 10,
          onTap: (index) => controller.setIndex(index),
          //other params
        ),
        body: IndexedStack(
          index: controller.getIndex(),
          children: [
            HomeView(),
            FavoriteView(),
            TransHistoryView(),
            SettingsView()
          ],
        ),
      ),
    );
  }
}
