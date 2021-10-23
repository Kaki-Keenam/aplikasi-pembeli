
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class Fcm extends GetxController{
  Rxn<String> _streamToken = Rxn<String>();

  late AndroidNotificationChannel channel;

  @override
  void onInit(){
    _streamToken.bindStream(FirebaseMessaging.instance.onTokenRefresh);
    super.onInit();
  }

  Future<void> initFirebaseMessaging({
    required String userId,
  }) async {
    try {
      print('INIT FIREBASE MESSAGING');
      // https://github.com/FirebaseExtended/flutterfire/issues/1684
      // TODO: looks like onmessage is fired twice for each message
      // need to look into it
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
      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.instance.getToken().then((value) => _streamToken.value = value);
      if (!kReleaseMode) debugPrint('Firebase messaging token: ${_streamToken.value}');

      print('CHANGE TOKEN!');
      CollectionReference users =
      FirebaseFirestore.instance.collection(Constants.BUYER);
      users
          .doc(userId)
          .update({
        'token': _streamToken.value,
      })
          .then((value) {})
          .catchError((error) {print("Failed update $error");});
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> onBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    handleMessage(message.data);
    return;
  }

  void handleMessage(Map<String, dynamic> message) {
    print(message);
    return;
  }
}