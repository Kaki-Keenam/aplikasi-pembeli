import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/modules/components/model_view/food_view.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';
import 'package:lottie/lottie.dart';

import '../controllers/favorite_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: true,
        title: Text('Favorite Makanan', style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w400, fontSize: 16)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Search
          Container(
            width: MediaQuery.of(context).size.width,
            height: 145,
            color: AppColor.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Search TextField
                      Expanded(
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.thirdSoft),
                          child: TextField(
                            onChanged: (value) {                         },
                            style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w400),
                            maxLines: 1,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: 'Apa yang ingin anda makan?',
                              hintStyle: TextStyle(color: Colors.black54.withOpacity(0.2)),
                              prefixIconConstraints: BoxConstraints(maxHeight: 20),
                              contentPadding: EdgeInsets.symmetric(horizontal: 17),
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              prefixIcon: Container(
                                margin: EdgeInsets.only(left: 10, right: 12),
                                child: SvgPicture.asset(
                                  'assets/icons/search.svg',
                                  width: 20,
                                  height: 20,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Filter Button
                      GestureDetector(
                        onTap: () {
                          // showModalBottomSheet(
                          //     context: context,
                          //     backgroundColor: Colors.white,
                          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                          //     builder: (context) {
                          //       return SearchFilterModal();
                          //     });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.secondary,
                          ),
                          child: SvgPicture.asset('assets/icons/filter.svg'),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Section 2 - Search Result
          Container(
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  if(controller.food != null && controller.food?.length != 0){
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: controller.food!.length,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16);
                      },
                      itemBuilder: (context, index) {
                        return FoodView(
                          product: controller.food?[index],
                          func: ()=> Get.toNamed(Routes.DETAILITEM, arguments: controller.food?[index]),
                        );
                      },
                    );
                  }else{
                    return Lottie.asset('assets/animation/no-data.zip');
                  }
                }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
