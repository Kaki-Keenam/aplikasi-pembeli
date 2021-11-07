import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/modules/components/model_view/food_nearby_view.dart';
import 'package:kakikeenam/app/modules/vendor_detail/controllers/vendor_detail_controller.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';
class ProductView extends GetView<VendorDetailController> {
  final String? vendorId;
  const ProductView({Key? key, this.vendorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder<List<ProductModel>>(
        stream: controller.getProduct(vendorId!),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3/4,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30),
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext ctx, index) {
                  return FoodNearbyView(
                    product: snapshot.data?[index],
                    func: ()=> Get.toNamed(Routes.DETAILITEM, arguments: snapshot.data?[index]),
                  );
                });
          }
          return Lottie.asset('assets/animation/no-data.zip');
        }
      ),
    );
  }
}
