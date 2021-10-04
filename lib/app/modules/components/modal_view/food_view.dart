import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';

class FoodView extends StatelessWidget {
  const FoodView({
    Key? key,
    this.func, this.product,
  }) : super(key: key);

  final ProductModel? product;
  final VoidCallback? func;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: 23,
            child: Container(
              height: 150,
              width: Get.width * 0.87,
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
              padding: EdgeInsets.symmetric(
                  vertical: 15, horizontal: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 135,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: Get.width * 0.35,
                            child: Text(
                              "Bakso lezat",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "animalKind",
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "15 years old",
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 135,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FaIcon(
                            FontAwesomeIcons.mapMarkerAlt,
                            color: Color(0xff416C6E),
                            size: 17,
                          ),
                          Text(
                            "Distance: 10 km",
                            style: TextStyle(
                              color: Colors.black26,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 23,
            child: Hero(
              tag: 'path',
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/vendor.png"),
                      fit: BoxFit.fill
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffCCD5D9),
                      Color(0xffB9C6CB)
                    ],
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
