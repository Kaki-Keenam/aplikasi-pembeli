import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/chat/views/chat_view.dart';
import 'package:kakikeenam/app/modules/favorite/views/favorite_view.dart';
import 'package:kakikeenam/app/modules/home/views/home_view.dart';
import 'package:kakikeenam/app/modules/maps_location/views/maps_location_view.dart';
import 'package:kakikeenam/app/modules/settings/views/settings_view.dart';
import 'package:kakikeenam/app/modules/trans_history/views/trans_history_view.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';

import '../custom_bottom_navigation_bar.dart';

class PageSwitcher extends StatefulWidget {
  @override
  _PageSwitcherState createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  int _selectedIndex = 0;

  _onItemTapped(int index) {
    if(index != 2){
      setState(() {
        _selectedIndex = index;
      });
    }else{
      Get.offAllNamed(Routes.MAPS_LOCATION);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          [
            HomeView(),
            FavoriteView(),
            MapsLocationView(),
            ChatView(),
            TransHistoryView(),
            SettingsView(),
          ][_selectedIndex],
          BottomGradientWidget(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
    );
  }
}

class BottomGradientWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -40,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(gradient: AppColor.bottomShadow),
      ),
    );
  }
}
