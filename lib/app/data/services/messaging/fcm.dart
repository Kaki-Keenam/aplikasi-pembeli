
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class Fcm{

  Future<void> initFirebaseMessaging({
    required String userId,
  }) async {
    try {
      print('INIT FIREBASE MESSAGING');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print('ON MESSAGE');
        if (!kReleaseMode) print('onMessage: ${message.data['body']}');

        if(message.data['state'] == 'PROPOSED'){
          Get.defaultDialog(
              title: 'Pesanan dikirim',
              middleText: 'Menunggu konfirmasi pesanan',
              textConfirm: 'Ok',
              onConfirm: (){
                if(Get.isDialogOpen == true){
                  Get.back();
                  Get.back();
                }
              }
          );
        }else if(message.data['state'] == 'OTW'){
          Get.defaultDialog(
              title: 'Pesanan diterima penjual',
              middleText: 'Silahkan menunggu penjual sampai di lokasi anda',
              textConfirm: 'Ok',
              onConfirm: (){
                if(Get.isDialogOpen == true){
                  Get.back();
                  Get.back();
                }
              }
          );
        }else if(message.data['state'] == 'ARRIVED'){
          Get.defaultDialog(
              title: 'Penjual sudah sampai dilokasi anda',
              middleText: 'Silahkan melakukan transaksi dengan penjual',
              textConfirm: 'Ok',
              onConfirm: (){
                if(Get.isDialogOpen == true){
                  Get.back();
                  Get.back();
                }
              }
          );
        }else{
          print('Completed');
        }

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