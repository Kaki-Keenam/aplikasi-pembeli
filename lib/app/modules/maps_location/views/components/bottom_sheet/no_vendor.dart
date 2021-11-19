import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class NoVendor extends StatelessWidget {
  NoVendor({
    Key? key,
    this.func,
    this.isDismissible = false,
  });

  final VoidCallback? func;
  final bool isDismissible;

  @override
  Widget build(BuildContext context) {
    return  Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: Get.height * 0.25,
              width: Get.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 6,
                      offset: Offset(0, -4), // changes position of shadow
                    ),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'Pedagang tidak berhasil ditemukan ?',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'inter'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Container(
                      width: Get.width,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: func,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: LottieBuilder.asset(
                                    'assets/animation/not-found.zip',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: Get.width * 0.1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.amber[600],
                                ),
                                child: Text(
                                  "Cari lagi",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
