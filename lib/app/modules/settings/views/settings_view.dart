import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
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
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
