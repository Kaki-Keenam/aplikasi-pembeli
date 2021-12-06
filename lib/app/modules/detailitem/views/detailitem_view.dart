import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/markers_model.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/modules/components/model_view/food_nearby_view.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_button.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/strings.dart';

import '../controllers/detailitem_controller.dart';

class DetailItemView extends GetView<DetailItemController> {
  final prod = Get.arguments as ProductModel;

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
              child: prod.image != null
                  ? CachedNetworkImage(
                      imageUrl: "${prod.image}",
                      fit: BoxFit.cover,
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
                            "${prod.name}",
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
                                  FutureBuilder<VendorModel>(
                                    future: controller.vendorDetail(prod.vendorId!),
                                    builder: (context, vendor) {
                                      return RatingBar.builder(
                                        initialRating: vendor.data?.rating ?? 0.0,
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
                                      );
                                    }
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FutureBuilder<int>(
                                    future: controller.reviews(prod.vendorId!),
                                    builder: (context, reviews) {
                                      return Text("${reviews.data} Ulasan");
                                    }
                                  ),
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
                                  FutureBuilder<VendorModel>(
                                    future: controller.vendorDetail(prod.vendorId!),
                                    builder: (context, vendor) {
                                      if(vendor.hasData){
                                        return Row(
                                          children: [
                                            Icon(Icons.location_on_sharp),
                                            Text(
                                                "${Geolocator.distanceBetween(controller.user.lastLocation!.latitude, controller.user.lastLocation!.longitude, vendor.data!.location!.latitude, vendor.data!.location!.longitude).toStringAsFixed(0)} meter"),
                                          ],
                                        );
                                      }
                                      return Container();
                                    }
                                  ),
                                  SizedBox(
                                    height: 10,
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
                                child: FutureBuilder<VendorModel>(
                                  future: controller.vendorDetail(prod.vendorId!),
                                  builder: (context, vendor) {
                                    if(vendor.hasData){
                                      return InkWell(
                                        onTap: () => Get.toNamed(Routes.VENDOR_DETAIL,
                                            arguments: Markers(
                                                id: vendor.data?.uid,
                                                image: vendor.data?.storeImage,
                                                name: vendor.data?.storeName,
                                                rating: vendor.data?.rating
                                            )),
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
                                                  child: vendor.data?.storeImage != null
                                                      ? CachedNetworkImage(
                                                    imageUrl:
                                                    "${vendor.data?.storeImage}",
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
                                                      borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                        Radius.circular(10),
                                                        bottomLeft:
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    width: Get.width * 0.45,
                                                    child: Text(
                                                      vendor.data?.storeName ??
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
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                      width: Get.width * 0.45,
                                                      child: FutureBuilder<List<Placemark> >(
                                                          future: controller.geoCoding.placemarkFromCoordinates(
                                                              vendor.data!.location!.latitude, vendor.data!.location!.longitude),
                                                          builder: (context, street) {
                                                            return Text(
                                                              "${street.data?.first.street} ${street.data?.first.subLocality}",
                                                              overflow: TextOverflow.fade,
                                                              maxLines: 1,
                                                              softWrap: false,
                                                            );
                                                          })),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(Strings.status),
                                                      Text(vendor.data?.status ??
                                                          Strings.loading),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    return Container();
                                  }
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
                                    controller.setTrans(prod);
                                  },
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
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      height: Get.height,
                      child: StreamBuilder<List<ProductModel>>(
                          stream: controller.getProduct(prod.vendorId!),
                          builder: (context, product) {
                            if (product.hasData) {
                              return GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 3 / 4,
                                          crossAxisSpacing: 30,
                                          mainAxisSpacing: 30),
                                  itemCount: product.data?.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return FoodNearbyView(
                                        product: product.data?[index],
                                        func: () {
                                          Get.offAndToNamed(Routes.DETAILITEM,
                                              arguments: [
                                                product.data?[index],
                                              ]);
                                        });
                                  });
                            }
                            return Container();
                          }),
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
                  controller.initFav(prod.productId.toString());
                },
                builder: (control) {
                  return Obx(
                    () => FloatingActionButton(
                      onPressed: () {
                        var toggle = controller.isFav.toggle();
                        if (toggle.value) {
                          control.addFavorite(prod);
                        } else {
                          control.removeFavorite(prod.productId.toString());
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
