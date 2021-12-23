
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/modules/components/model_view/food_view.dart';
import 'package:kakikeenam/app/modules/near_vendor/controllers/near_vendor_controller.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/strings.dart';
import 'package:lottie/lottie.dart';

class NearVendorView extends GetView<NearVendorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.all_title),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        height: Get.height,
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
                        if (product.hasData &&
                            vendor.data!.isNotEmpty) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: product.data?.length ?? 3,
                            itemBuilder: (context, index) {
                              return StreamBuilder<VendorModel>(
                                stream: controller.getVendor(
                                    product.data?[index].vendorId),
                                builder: (context, vendor) {
                                  return FoodView(
                                    buyerLoc: buyer.data,
                                    vendor: vendor.data,
                                    product: product.data?[index],
                                    func: () => Get.toNamed(
                                        Routes.DETAILITEM,
                                        arguments: product.data?[index]),
                                  );
                                }
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
                      child: Lottie.asset(Strings.radar)
                  );
                },
              );
            }
            return Container();
          },
        ),
      )
    );
  }
}
