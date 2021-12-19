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
    this.product, this.vendor, this.buyerLoc, this.subscribed = false,
  }) : super(key: key);

  final ProductModel? product;
  final VendorModel? vendor;
  final GeoPoint? buyerLoc;
  final VoidCallback? func;
  final bool subscribed;

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 150,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: func,
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Positioned(
                left: -35,
                child: Container(
                  height: 130,
                  width: Get.width,
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
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
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
                            symbol: "Rp",
                          ).format(product?.price)}",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8),
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
                                    vendor!.location!.longitude).toStringAsFixed(0)} meter",
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
                  ),
                ),
              ),
              Positioned(
                child: Hero(
                  tag: '${product?.name} path',
                  child: Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffCCD5D9), Color(0xffB9C6CB)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
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
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                        : Icon(Icons.error),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
