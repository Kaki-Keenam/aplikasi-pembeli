import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/services/location_service.dart';
import 'package:kakikeenam/app/utils/strings.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    final statusC = Get.find<LocationController>();
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
                      onTap: () {},
                      leading: Icon(Icons.language),
                      title: Text(
                      Strings.change_lang,
                      ),
                      trailing: Text(Strings.indo),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Icon(Icons.location_on_rounded),
                      title: Text(
                        Strings.set_realtime,
                      ),
                      trailing: Obx(() => Switch(
                            value: statusC.statusStream.value,
                            onChanged: (value) {
                              // statusC.toggleListening();
                              statusC.statusStream.value = value;
                            }),
                      ),
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
