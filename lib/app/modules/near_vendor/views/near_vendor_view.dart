import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kakikeenam/app/data/database/database.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/modules/components/model_view/food_view.dart';
import 'package:kakikeenam/app/modules/components/widgets/loading_view.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

import '../controllers/near_vendor_controller.dart';

class NearVendorView extends GetView<NearVendorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedagang Terdekat'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        height: Get.height,
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
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
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
      )
    );
  }
}
