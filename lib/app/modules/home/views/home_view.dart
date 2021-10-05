import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/data/database/database.dart';
import 'package:kakikeenam/app/data/models/carousels_model.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/modules/components/modal_view/food_view.dart';
import 'package:kakikeenam/app/modules/components/widgets/loading_view.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Get.height * 0.3),
        child: AppBar(
          elevation: 0,
          titleSpacing: 10,
          title: Text(
            "Kaki Keenam",
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none_outlined,
                color: Colors.white,
              ),
            ),
            Container(
              width: 45,
              height: 45,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Get.toNamed(Routes.PROFILE);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Obx(() {
                        if (authC.userValue.photoUrl != null) {
                          return CachedNetworkImage(
                            imageUrl: "${authC.userValue.photoUrl}",
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Transform.scale(
                              scale: 0.5,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Image.asset(Constants.PROFILE);
                      }),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
          flexibleSpace: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Obx(
              () => Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: Get.height * 0.1),
                      width: Get.width,
                      height: Get.height * 0.18,
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
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Container(
                height: Get.height * 0.56,
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
                                if (product.hasData && vendor.data!.isNotEmpty) {
                                  return ListView.builder(
                                    itemCount: product.data?.length,
                                    itemBuilder: (context, index) {
                                      return FoodView(
                                        product: product.data?[index],
                                        func: () => Get.toNamed(Routes.DETAILITEM,
                                            arguments: product.data?[index]),
                                      );
                                    },
                                  );
                                }
                                return LoadingView();
                              },
                            );
                          }
                          return Center(
                            child: Text(
                              "Tidak ada pedagang disekitar anda !",
                            ),
                          );
                        },
                      );
                    }
                    return LoadingView();
                  },
                ),
              ),
        ],
      ),
    );
  }
}
