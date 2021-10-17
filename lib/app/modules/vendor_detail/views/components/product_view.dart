import 'package:flutter/material.dart';
import 'package:kakikeenam/app/data/database/database.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/modules/components/model_view/food_nearby_view.dart';
import 'package:lottie/lottie.dart';
class ProductView extends StatelessWidget {
  final String? vendorId;
  const ProductView({Key? key, this.vendorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder<List<ProductModel>>(
        stream: Database().getStreamProduct(vendorId!),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 4/5,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext ctx, index) {
                  return FoodNearbyView(
                    product: snapshot.data?[index],
                  );
                });
          }
          return Lottie.asset('assets/animation/no-data.zip');
        }
      ),
    );
  }
}
