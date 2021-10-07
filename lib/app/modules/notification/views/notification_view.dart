import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kakikeenam/app/data/services/location_service.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        centerTitle: true,
      ),
    );
  }
}
