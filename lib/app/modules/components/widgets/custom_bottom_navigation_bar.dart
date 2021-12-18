
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  CustomBottomNavigationBar({required this.selectedIndex, required this.onItemTapped});

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.thirdSoft,
            offset: Offset(0, 1),
            blurRadius: 10,
            spreadRadius: 1
          )
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            currentIndex: widget.selectedIndex,
            onTap: widget.onItemTapped,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: [
              (widget.selectedIndex == 0)
                  ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/home-filled.svg', color: AppColor.primary), label: '')
                  : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/home.svg', color: Colors.grey[600]), label: ''),
              (widget.selectedIndex == 1)
                  ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/bookmark-filled.svg', color: AppColor.primary), label: '')
                  : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/bookmark.svg', color: Colors.grey[600]), label: ''),
              (widget.selectedIndex == 2)
                  ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/discover-filled.svg', color: AppColor.primary, height: 28, width: 26), label: '')
                  : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/discover.svg', color: Colors.grey[600], height: 28, width: 26), label: ''),
              (widget.selectedIndex == 3)
                  ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Chat-filled.svg', color: AppColor.primary, height: 25, width: 23), label: '')
                  : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Chat.svg', color: Colors.grey[600], height: 25, width: 23), label: ''),
              (widget.selectedIndex == 4)
                  ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/time-circle-filled.svg', color: AppColor.primary,  height: 28, width: 26), label: '')
                  : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/time-circle.svg', color: Colors.grey[600],  height: 28, width: 26), label: ''),
              (widget.selectedIndex == 5)
                  ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/setting-filled.svg', color: AppColor.primary,  height: 28, width: 26), label: '')
                  : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/setting.svg', color: Colors.grey[600],  height: 28, width: 26), label: ''),
            ],
          ),
        ),
      ),
    );
  }
}
