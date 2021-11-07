
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/modules/components/model_view/food_view.dart';
import 'package:kakikeenam/app/modules/home/controllers/home_controller.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/strings.dart';

class NearVendorView extends GetView<HomeController> {
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
        child: StreamBuilder<List<ProductModel>?>(
          stream: controller.streamProduct(controller.vendorID),
          builder: (context, product) {
            if (product.hasData) {
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
            return Container();
          },
        )
      )
    );
  }
}
