import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/banner_model.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/modules/components/model_view/food_view.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_app_bar.dart';
import 'package:kakikeenam/app/modules/components/widgets/search_bar.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';
import 'package:kakikeenam/app/utils/strings.dart';
import 'package:lottie/lottie.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(Strings.home_title,
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
                height: Get.height * 0.34,
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
                  FutureBuilder<BannerModel>(
                      future: controller.getBanner(),
                      builder: (context, banner) {
                        var data = banner.data?.result;
                        if (banner.hasData) {
                          return Column(
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
                                  itemCount: data!.length,
                                  itemBuilder: (BuildContext context, index) {
                                    return data[index].image != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl: "${data[index].image}",
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) =>
                                                  Transform.scale(
                                                scale: 0.5,
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                          )
                                        : Icon(Icons.error);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Obx(() {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: controller.map<Widget>(data,
                                      (index, image) {
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      height: 6,
                                      width: 6,
                                      margin: EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: controller.currentIndex.value ==
                                                index
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                    );
                                  }),
                                );
                              }),
                            ],
                          );
                        }
                        return Container();
                      }),
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
                      Strings.near_food,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'inter'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.NEAR_VENDOR);
                      },
                      child: Text(Strings.see_all),
                      style: TextButton.styleFrom(
                          primary: Colors.black,
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ),
                  ],
                ),
                Container(
                  height: Get.height * 0.67,
                  width: double.infinity,
                  child: StreamBuilder<GeoPoint>(
                    stream: controller.getBuyerLoc(),
                    builder: (context, buyer) {
                      if (buyer.hasData) {
                        return StreamBuilder<List<VendorModel>?>(
                          stream: controller.getVendorId(buyer.data),
                          builder: (context, vendor) {
                            if (vendor.hasData && vendor.data!.isNotEmpty) {
                              return StreamBuilder<List<ProductModel>?>(
                                stream: controller.getNearProduct(vendor.data),
                                builder: (context, product) {
                                  if (product.hasData) {
                                    controller.searchList.value = product.data;
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: product.data?.length ?? 3,
                                      itemBuilder: (context, index) {
                                        return FutureBuilder<VendorModel>(
                                            future: controller.getVendor(
                                                product.data?[index].vendorId),
                                            builder: (context, vendor) {
                                              return FoodView(
                                                buyerLoc: buyer.data,
                                                vendor: vendor.data,
                                                product: product.data?[index],
                                                func: () => Get.toNamed(
                                                    Routes.DETAILITEM,
                                                    arguments: [
                                                      product.data?[index],
                                                      vendor.data,
                                                      buyer.data
                                                    ]),
                                              );
                                            });
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
                            return Center(child: Lottie.asset(Strings.radar));
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
