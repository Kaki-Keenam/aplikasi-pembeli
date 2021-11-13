import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/modules/components/model_view/food_view.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';
import 'package:kakikeenam/app/utils/strings.dart';
import 'package:lottie/lottie.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(Strings.search_title, style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w400, fontSize: 16)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Get.back();
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
                            onChanged: (value) {
                              controller.searchFood(value);                            },
                            style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w400),
                            maxLines: 1,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: Strings.search_food,
                              hintStyle: TextStyle(color: Colors.black54.withOpacity(0.2)),
                              prefixIconConstraints: BoxConstraints(maxHeight: 20),
                              contentPadding: EdgeInsets.symmetric(horizontal: 17),
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              prefixIcon: Container(
                                margin: EdgeInsets.only(left: 10, right: 12),
                                child: SvgPicture.asset(
                                  Strings.search,
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
                          child: SvgPicture.asset(Strings.filter),
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
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text(
                    Strings.search_result,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                Obx(() {
                  if(controller.searchResult != null && controller.searchResult?.length != 0){
                    return StreamBuilder<GeoPoint>(
                      stream: controller.getBuyerLoc(),
                      builder: (context, buyer) {
                        if(buyer.hasData){
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: controller.searchResult!.length,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 16);
                            },
                            itemBuilder: (context, index) {
                              return FutureBuilder<VendorModel>(
                                  future: controller.getVendor(controller.searchResult?[index].vendorId),
                                  builder: (context, vendor) {
                                    return FoodView(
                                      buyerLoc: buyer.data,
                                      vendor: vendor.data,
                                      product: controller.searchResult?[index],
                                      func: () => Get.toNamed(
                                        Routes.DETAILITEM,
                                        arguments: [
                                          controller.searchResult?[index],
                                          vendor.data,
                                          buyer.data
                                        ]),
                                    );
                                  }
                              );
                            },
                          );
                        }
                        return Container();
                      }
                    );
                  }else{
                    return StreamBuilder<GeoPoint>(
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
                    );
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
