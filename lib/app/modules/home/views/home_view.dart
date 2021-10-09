import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/data/database/database.dart';
import 'package:kakikeenam/app/data/models/carousels_model.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/modules/components/model_view/food_view.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_app_bar.dart';
import 'package:kakikeenam/app/modules/components/widgets/search_bar.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Anda Lapar?',
            style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w700)),
        showProfilePhoto: true,
        profilePhotoOnPressed: () {
          Get.toNamed(Routes.PROFILE);
        },
      ),
      body: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          // Section 1 - Featured Recipe - Wrapper
          Stack(
            children: [
              Container(
                height: 245,
                color: AppColor.primary,
              ),
              // Section 1 - Content
              Column(
                children: [
                  // Search Bar
                  SearchBar(
                    routeTo: () {
                      Get.toNamed(Routes.SEARCH);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Obx(
                    () => Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          width: Get.width,
                          height: Get.height * 0.21,
                          child: Swiper(
                            onIndexChanged: (index) {
                              controller.currentIndex.value = index;
                            },
                            autoplay: true,
                            layout: SwiperLayout.DEFAULT,
                            itemCount: corousels.length,
                            itemBuilder: (BuildContext context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: AssetImage(
                                        corousels[index].image ?? "Loading",
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              controller.map<Widget>(corousels, (index, image) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              height: 6,
                              width: 6,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.currentIndex.value == index
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          // Section 3 - Newly Posted
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Makanan Terdekat',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'inter'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.NEAR_VENDOR);
                      },
                      child: Text('see all'),
                      style: TextButton.styleFrom(
                          primary: Colors.black,
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ),
                  ],
                ),
                // Content
                // ListView.separated(
                //   shrinkWrap: true,
                //   itemCount: 3 ,//?? newlyPostedRecipe.length,
                //   physics: NeverScrollableScrollPhysics(),
                //   separatorBuilder: (context, index) {
                //     return SizedBox(height: 16);
                //   },
                //   itemBuilder: (context, index) {
                //     return RecipeTile(
                //       data: newlyPostedRecipe[index],
                //     );
                //   },
                // ),
                Container(
                  height: Get.height * 0.67,
                  width: double.infinity,
                  child: StreamBuilder<GeoPoint>(
                    stream: Database().streamBuyerLoc(),
                    builder: (context, buyer) {
                      if (buyer.hasData) {
                        return StreamBuilder<List<VendorModel>?>(
                          stream: Database().streamVendorId(buyer.data),
                          builder: (context, vendor) {
                            if (vendor.hasData && vendor.data!.isNotEmpty) {
                              return StreamBuilder<List<ProductModel>>(
                                stream: Database().streamProduct(vendor.data),
                                builder: (context, product) {
                                  if (product.hasData &&
                                      vendor.data!.isNotEmpty) {
                                    controller.searchList.value = product.data;
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: product.data?.length ?? 3,
                                      itemBuilder: (context, index) {
                                        return FoodView(
                                          product: product.data?[index],
                                          func: () => Get.toNamed(
                                              Routes.DETAILITEM,
                                              arguments: product.data?[index]),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: 16,
                                        );
                                      },
                                    );
                                  }
                                  return Container();
                                },
                              );
                            }
                            return Center(
                              child: Lottie.asset('assets/animation/radar.zip')
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
