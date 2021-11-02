
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class Fcm extends GetxController{

  Future<void> initFirebaseMessaging({
    required String userId,
  }) async {
    try {
      print('INIT FIREBASE MESSAGING');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print('ON MESSAGE');
        if (!kReleaseMode) print('onMessage: ${message.data['body']}');

        Get.defaultDialog(
          title: 'Pesanan dikirim',
          textConfirm: 'Ok',
          onConfirm: ()=> Get.back()
        );
        handleMessage(message.data);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        print('ON MESSAGE OPENED APP');
        if (!kReleaseMode) print('onLaunch: $message');
        handleMessage(message.data);
      });

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      await FirebaseMessaging.instance.deleteToken();
      var token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      if (!kReleaseMode) debugPrint('Firebase messaging token: $token');

      print('CHANGE TOKEN!');
      CollectionReference users =
      FirebaseFirestore.instance.collection(Constants.BUYER);
      users
          .doc(userId)
          .update({
        'token': token,
      })
          .then((value) {})
          .catchError((error) { print("Failed to update user: $error");});

    } catch (ex) {
      print(ex);
    }
  }

  void handleMessage(Map<String, dynamic> message) {
    print(message);
    return;
  }
}