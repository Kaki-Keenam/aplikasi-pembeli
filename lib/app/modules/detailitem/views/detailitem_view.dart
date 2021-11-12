import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/components/model_view/food_nearby_view.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_button.dart';
import 'package:kakikeenam/app/modules/components/widgets/loading_view.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/strings.dart';

import '../controllers/detailitem_controller.dart';

class DetailItemView extends GetView<DetailItemController> {
  final food = Get.arguments as List;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: Get.height * 0.5,
              width: Get.width,
              child: food[0]?.image != null
                  ? CachedNetworkImage(
                imageUrl: "${food[0]?.image}",
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    Transform.scale(
                      scale: 0.5,
                      child: CircularProgressIndicator(),
                    ),
              )
                  : Icon(Icons.error),
            ),
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Container(
              margin: EdgeInsets.only(top: Get.height * 0.45),
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: -1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${food[0]?.name}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 3.5,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 20,
                                    itemBuilder: (context, _) =>
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("200 reviews"),
                                ],
                              ),
                              Center(
                                child: Container(
                                  height: 70,
                                  width: 1,
                                  color: Colors.black45,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_sharp),
                                      Obx(
                                            () =>
                                            Text(
                                                "${controller.getVendorModel
                                                    .distance?.toStringAsFixed(
                                                    0)} ${Strings.distance}"),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.watch_later_outlined),
                                      Text("500 Menit")
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Center(
                            child: Container(
                              width: Get.width,
                              height: 1,
                              color: Colors.black45,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: Get.width,
                              height: Get.height * 0.18,
                              child: Row(
                                children: [
                                  Container(
                                    height: Get.height * 0.18,
                                    width: Get.width * 0.35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            topLeft: Radius.circular(10)),
                                        child: food[1].storeImage !=
                                            null
                                            ? CachedNetworkImage(
                                          imageUrl:
                                          "${food[1].storeImage}",
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) =>
                                              Transform.scale(
                                                scale: 0.5,
                                                child:
                                                CircularProgressIndicator(),
                                              ),
                                        )
                                            : Container(
                                          height: Get.height * 0.18,
                                          width: Get.width * 0.35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft: Radius.circular(
                                                      10)
                                              )
                                          ),
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Container(
                                        width: Get.width * 0.45,
                                        child: Text(
                                          food[1].storeName ??
                                              Strings.loading,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        Strings.position,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        width: Get.width * 0.45,
                                        child: Obx(() {
                                          return Text(
                                            controller.getVendorModel.street ??
                                                Strings.loading,
                                            overflow: TextOverflow.ellipsis,);
                                        }),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(Strings.status),
                                          Text(food[1].status ??
                                              Strings.loading),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 4,
                                child: CustomButton(
                                  text: Strings.call_know,
                                  backgroundColor: Colors.amber[600],
                                  func: () {
                                    controller.setTrans(food[0]);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    child: Center(
                                      child: Icon(
                                        Icons.message,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 30),
                    child: Text(
                      Strings.other_foods,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                          () =>
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 4,
                                    crossAxisSpacing: 30,
                                    mainAxisSpacing: 30),
                                itemCount: controller.foodOther?.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  if (food[0].vendorId != null) {
                                    controller.setVendorId = food[0].vendorId;
                                    return FoodNearbyView(
                                        product: controller.foodOther?[index],
                                        func: () {
                                          Navigator.pushReplacementNamed(
                                              context, Routes.DETAILITEM,
                                              arguments:
                                              controller.foodOther?[index]);
                                        });
                                  }
                                  return LoadingView();
                                }),
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: Get.width * 0.1,
              top: Get.height * 0.4,
              child: GetBuilder<DetailItemController>(
                initState: (_) {
                  controller.initFav(food[0].productId.toString());
                },
                builder: (control) {
                  return Obx(
                        () =>
                        FloatingActionButton(
                          onPressed: () {
                            var toggle = controller.isFav.toggle();
                            if (toggle.value) {
                              control.addFavorite(food: food[0]);
                            } else {
                              control.removeFavorite(
                                  food[0].productId.toString());
                            }
                          },
                          backgroundColor: Colors.amber[600],
                          child: control.isFav.value
                              ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                              : Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
