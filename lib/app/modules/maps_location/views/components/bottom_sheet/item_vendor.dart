import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemVendor extends StatelessWidget {

  ItemVendor({Key? key, this.isDismissible = false, this.func});

  final bool isDismissible;
  final VoidCallback? func;

  @override
  Widget build(BuildContext context) {
    return isDismissible
        ? Container()
        : Positioned(
            bottom: 0,
            child: Container(
              height: Get.height * 0.3,
              width: Get.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 6), // changes position of shadow
                    ),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: func,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/merchant.png"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Kaki Lima Keliling",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 2,
                    thickness: 1,
                  ),
                  Container(
                    width: Get.width,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        focusColor: Colors.amber,
                        onTap: func,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/vendor.png"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Kaki Lima Tetap",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 2,
                    thickness: 1,
                  ),
                ],
              ),
            ),
          );
  }
}
