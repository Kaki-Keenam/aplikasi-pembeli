import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/components/model_view/food_view.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';
import 'package:kakikeenam/app/utils/strings.dart';
import 'package:lottie/lottie.dart';

import '../controllers/favorite_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  // final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(Strings.favorite_title,
            style: TextStyle(
                fontFamily: 'inter',
                fontWeight: FontWeight.w400,
                fontSize: 16)),
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.thirdSoft),
                          child: TextField(
                            controller: controller.searchInputController,
                            onChanged: (value) {
                              controller.searchFood(value);
                              print("keyword: ${value}");
                            },
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                            maxLines: 1,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: Strings.fav_search,
                              hintStyle: TextStyle(
                                  color: Colors.black54.withOpacity(0.2)),
                              prefixIconConstraints:
                                  BoxConstraints(maxHeight: 20),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 17),
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      // Filter Button
                      GestureDetector(
                        onTap: () {
                          controller.searchFood(
                              controller.searchInputController.text);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.secondary,
                          ),
                          child: SvgPicture.asset(Strings.search),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  margin: EdgeInsets.only(top: 8),
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.popularRecipeKeyword.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 8);
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.topCenter,
                        child: TextButton(
                          onPressed: () {
                            controller.searchInputController.text =
                                controller.popularRecipeKeyword[index];
                          },
                          child: Text(
                            controller.popularRecipeKeyword[index],
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w400),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.15),
                                width: 1,),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          // Section 2 - Search Result
          Container(
            padding: EdgeInsets.all(16),
            height: Get.height * 0.62,
            width: MediaQuery.of(context).size.width,
            child: Obx(() {
              if (controller.searchResult != null && controller.searchInputController.text.isNotEmpty) {
                return ListView.separated(
                  itemCount: controller.searchResult!.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 16);
                  },
                  itemBuilder: (context, index) {
                    return FoodView(
                      subscribed: true,
                      product: controller.searchResult?[index],
                      func: () => Get.toNamed(Routes.DETAILITEM,
                          arguments: controller.searchResult?[index]),
                    );
                  },
                );
              } else if (controller.food != null && controller.food?.length != 0) {
                return ListView.separated(
                  itemCount: controller.food!.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 16);
                  },
                  itemBuilder: (context, index) {
                    return FoodView(
                      subscribed: true,
                      product: controller.food?[index],
                      func: () => Get.toNamed(Routes.DETAILITEM,
                          arguments: controller.food?[index]),
                    );
                  },
                );
              }
              return Lottie.asset(Strings.no_data);
            }),
          ),
        ],
      ),
    );
  }
}
