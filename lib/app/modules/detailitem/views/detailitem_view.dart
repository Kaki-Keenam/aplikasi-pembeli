import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_button.dart';

import '../controllers/detailitem_controller.dart';

class DetailItemView extends GetView<DetailItemController> {
  final authC = Get.find<AuthController>();
  final food = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[600],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    height: Get.height * 0.4,
                    child: CachedNetworkImage(
                      imageUrl: food.image,
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 10,
                  ),
                  flex: 6,
                ),
              ],
            ),
            AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            Container(
              margin: EdgeInsets.only(top: Get.height * 0.4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: "roboto"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.values[4],
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
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
                              Padding(
                                padding: EdgeInsets.only(top: 15, left: 5),
                                child: Text(
                                  "${food.rating} reviews)",
                                  style: TextStyle(
                                      fontSize: 10, fontFamily: "roboto"),
                                ),
                              )
                            ],
                          ),
                          Center(
                            child: Container(
                              height: 80,
                              width: 1,
                              color: Colors.black12,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("500 M dari sini")
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Row(
                                  children: [
                                    Icon(Icons.timer),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("5 menit")
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),

                      Center(
                        heightFactor: 12,
                        child: Container(
                          height: 1,
                          width: 550,
                          color: Colors.black12,
                        ),
                      ),
                      // vendor card
                      Flexible(
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            height: 150,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          "assets/images/vendor.png"),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 10),
                                        child: Text(
                                          "${food.vendor}",
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              fontFamily: "roboto"),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 15),
                                        child: Text(
                                          "Posisi Saat ini:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontFamily: "roboto"),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 5),
                                        child: Text(
                                            "Jln Tgh Amrillah Bunut Baok praya",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF444444),
                                                fontFamily: "roboto")),
                                      ),
                                      Container(
                                        width: Get.width * 0.4,
                                        padding:
                                            EdgeInsets.only(left: 10, top: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                "Kabari pedagang",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "roboto"),
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.amber[700],
                                                ),
                                                child: Icon(Icons
                                                    .notifications_none_outlined),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 4,
                            child: CustomButton(
                              text: "Beli Sekarang",
                              backgroundColor: Colors.amber[600],
                              func: () {
                                print("${controller.isFav.value}");
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
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: Get.width * 0.1,
              top: Get.height * 0.37,
              child: GetBuilder<DetailItemController>(
                initState: (_){
                  controller.initFav(food.id.toString());
                },
                builder: (c){
                return Obx(() => FloatingActionButton(
                    onPressed: () {
                      var toggle = controller.isFav.toggle();
                      if (toggle.value) {
                        print("${controller.isFav.value}");
                        c.addFavorite(
                          id: food.id.toString(),
                          title: food.title,
                          rating: food.rating.toString(),
                          image: food.image,
                          vendor: food.vendor,
                        );
                      } else {
                        c.removeFavorite(food.id.toString());
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
