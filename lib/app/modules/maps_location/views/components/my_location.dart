import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// This is Widget current location Button
class MyLocation extends StatelessWidget {
  const MyLocation({
    Key? key,
    this.func,
    this.isDismissible = false,
  }) : super(key: key);

  final VoidCallback? func;
  final bool isDismissible;

  @override
  Widget build(BuildContext context) {
    return isDismissible
        ? Container()
        : Positioned(
            bottom: Get.height * 0.32,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: func,
              child: Icon(
                Icons.location_searching_rounded,
                color: Colors.black45,
              ),
            ),
          );
  }
}
