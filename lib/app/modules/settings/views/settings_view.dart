import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kakikeenam/app/data/services/location_service.dart';
import 'package:kakikeenam/app/utils/strings.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    final statusC = Get.find<LocationController>();
    final box = GetStorage();
    if (box.read('location') != null) {
      var data = box.read('location');
      print('status $data');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.settings,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.defaultDialog(
                          title: 'Terimakasi sudah melakukan transaksi',
                          titleStyle: TextStyle(fontSize: 18),
                          titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          content: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                            child: Column(
                              children: [
                                Text('Berikan penilaian untuk pedagang'),
                                SizedBox(height: 15,),
                                RatingBar.builder(
                                  minRating: 1,
                                  itemSize: 40,
                                  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.orangeAccent,),
                                  onRatingUpdate: (rating){
                                    print(rating);
                                  },
                                )
                              ],
                            ),
                          ),
                          textConfirm: 'Ok',
                          onConfirm: (){
                            if(Get.isDialogOpen == true){
                              Get.back();
                            }
                          }
                      );
                    },
                    leading: Icon(Icons.language),
                    title: Text(
                      Strings.change_lang,
                    ),
                    trailing: Text(Strings.indo),
                  ),
                  ListTile(
                      leading: Icon(Icons.location_on_rounded),
                      title: Text(
                        Strings.set_realtime,
                      ),
                      trailing:
                      Obx(() {
                        return Switch(
                            value: controller.isRealtime
                                .value,
                            onChanged: (value) {
                              print('val $value');
                                statusC.toggleListening();
                              controller.isLocationEnable(value);
                            });
                      })
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
