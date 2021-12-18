import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';

class SearchBar extends StatelessWidget {
  final VoidCallback routeTo;
  SearchBar({required this.routeTo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: routeTo,
      child: Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 50,
                margin: EdgeInsets.only(right: 15),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.thirdSoft),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/search.svg', color: Colors.black54, height: 18, width: 18),
                    Container(
                      width: Get.width * 0.55,
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        'Cari makan disini'
                            '',
                        style: TextStyle(color: Colors.black54.withOpacity(0.3)),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Right side - filter button
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.secondary,
              ),
              child: SvgPicture.asset('assets/icons/filter.svg'),
            )
          ],
        ),
      ),
    );
  }
}
