import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/services/location_service.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    final statusC = Get.find<LocationController>();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
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
                        "Ganti bahasa",
                      ),
                      trailing: Text("Bahasa Indonesia"),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Icon(Icons.location_on_rounded),
                      title: Text(
                        "Realtime Lokasi anda",
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
