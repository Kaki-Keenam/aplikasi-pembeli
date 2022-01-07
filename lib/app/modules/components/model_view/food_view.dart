import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';


class FoodView extends StatelessWidget {
  const FoodView({
    Key? key,
    this.func,
    this.product,
    this.vendor,
    this.buyerLoc,
    this.subscribed = false,
  }) : super(key: key);

  final ProductModel? product;
  final VendorModel? vendor;
  final GeoPoint? buyerLoc;
  final VoidCallback? func;
  final bool subscribed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: Get.height * 0.19,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: Offset(0, 15),
              spreadRadius: -6,
              blurRadius: 15,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                child: Container(
                  height: 150,
                  width: Get.width,
                  child: Row(
                    children: [
                      Hero(
                        tag: '${product?.name} path',
                        child: Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                offset: Offset(-10, 15),
                                spreadRadius: -6,
                                blurRadius: 15,
                              )
                            ],
                          ),
                          child: product?.image != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: "${product?.image}",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                              : Image.asset('assets/images/no-food.png', scale: 2.6,),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Get.width * 0.45,
                              child: Text(
                                "${product?.name}",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: Get.width * 0.45,
                              child: Text(
                                "${product?.vendorName}",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${NumberFormat.currency(
                                name: "id",
                                decimalDigits: 0,
                                symbol: "Rp ",
                              ).format(product?.price)}",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 10),
                            subscribed == false ? SizedBox(
                              width: Get.width * 0.45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  FaIcon(
                                    FontAwesomeIcons.mapMarkerAlt,
                                    color: Color(0xff416C6E),
                                    size: 17,
                                  ),
                                  SizedBox(width: 10,),
                                  buyerLoc != null && vendor != null ? Text(
                                    "Jarak: ${Geolocator.distanceBetween(
                                        buyerLoc!.latitude,
                                        buyerLoc!.longitude,
                                        vendor!.location!.latitude,
                                        vendor!.location!.longitude).toStringAsFixed(0).length == 4 ? Geolocator.distanceBetween(
                                        buyerLoc!.latitude,
                                        buyerLoc!.longitude,
                                        vendor!.location!.latitude,
                                        vendor!.location!.longitude).toStringAsExponential(2).substring(0,3) + " km" : Geolocator.distanceBetween(
                                        buyerLoc!.latitude,
                                        buyerLoc!.longitude,
                                        vendor!.location!.latitude,
                                        vendor!.location!.longitude).toStringAsFixed(0) + " meter"} ",
                                    style: TextStyle(
                                      color: Colors.black26,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),

                                  ): Container(),
                                ],
                              ),
                            ): Container(
                              width: 100,
                              height: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red
                              ),
                              child: Center(child: Text("Langganan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

            ),
          ],
        ),
      ),
    );
  }
}
