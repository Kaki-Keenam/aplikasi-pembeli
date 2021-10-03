import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/data/services/transaction/transaction_state.dart';
import 'package:kakikeenam/app/modules/components/modal_view/food_nearby_view.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_button.dart';
import 'package:kakikeenam/app/modules/components/widgets/loading_view.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

import '../controllers/detailitem_controller.dart';

class DetailItemView extends GetView<DetailItemController> {
  final authC = Get.find<AuthController>();
  final idleC = Get.find<Transaction_state_controller>();
  final food = Get.arguments;

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
              child: food?.image != null
                  ? CachedNetworkImage(
                      imageUrl: "${food!.image}",
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Transform.scale(
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${food.name}",
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
                              itemBuilder: (context, _) => Icon(
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
                                Icon(Icons.add_location),
                                Text("500 M dari sini")
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
                        height: Get.height * 0.2,
                        child: Row(
                          children: [
                            Container(
                              height: Get.height * 0.2,
                              width: Get.width * 0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Obx(() {
                                return controller.vendor.value.image != null
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            "${controller.vendor.value.image}",
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            Transform.scale(
                                          scale: 0.5,
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : Icon(Icons.error);
                                return CircularProgressIndicator();
                              }),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: Get.width * 0.5,
                                  child: Obx(
                                    () => Text(
                                      controller.vendor.value.storeName ??
                                          "Loading",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Posisi saat ini:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Obx(
                                  () =>
                                      Text("${controller.vendor.value.street}"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Obx(() => Text("Status:" +
                                    " ${controller.vendor.value.status}")),
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
                            text: "Panggil Sekarang",
                            backgroundColor: Colors.amber[600],
                            func: () {
                              idleC.stateProposedTrans(food);
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
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 200,
                      width: Get.width,
                      child: Obx(
                        () => ListView.builder(
                          itemCount: controller.foodOther?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            if (food.vendorId != null) {
                              controller.setVendorId = food.vendorId;
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
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: Get.width * 0.1,
              top: Get.height * 0.4,
              child: GetBuilder<DetailItemController>(
                initState: (_) {
                  controller.initFav(food.productId.toString());
                },
                builder: (c) {
                  return Obx(
                    () => FloatingActionButton(
                      onPressed: () {
                        var toggle = controller.isFav.toggle();
                        if (toggle.value) {
                          c.addFavorite(food: food);
                        } else {
                          c.removeFavorite(food.productId.toString());
                        }
                      },
                      backgroundColor: Colors.amber[600],
                      child: c.isFav.value
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
