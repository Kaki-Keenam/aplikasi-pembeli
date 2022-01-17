import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/maps_location/controllers/maps_location_controller.dart';

class LoadingVendor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapC = Get.find<MapsLocationController>();
    Future.delayed(Duration(milliseconds: 5000), () {
      Get.back();
      Future.delayed(Duration(seconds: 2), () {
        mapC.isLoadingDismiss.value = true;
        mapC.isDismissibleEmpty.value = true;
      });
    });
    return Material(
      child: Container(
        height: Get.height * 0.15,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 6),
                width: Get.width * 0.1,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: Get.height * 0.1,
              width: Get.width * 0.85,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: ListTile(
                  title: Text('Mencari Kaki Lima Keliling ...'),
                  leading: Image.asset("assets/images/merchant.png"),
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
