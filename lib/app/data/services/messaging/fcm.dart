

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';
import 'package:kakikeenam/app/utils/utils.dart';

enum StateDialog {
  NONE,
  REJECTED,
  PROPOSED,
  OTW,
  ARRIVED,
  FINISHED
}

class Fcm {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();

  Future<void> initFirebaseMessaging({
    String? userId, UserModel? user,
  }) async {
    try {
      print('INIT FIREBASE MESSAGING');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print('ON MESSAGE');
        if (!kReleaseMode) print('onMessage: ${message.data}');
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
      users.doc(userId)
          .update({
            'token': token,
          })
          .then((value) {})
          .catchError((error) {
            print("Failed to update user: $error");
          });
    } catch (ex) {
      print(ex);
    }
  }

  void handleMessage(Map<String, dynamic> message, [UserModel? user]) {
    StateDialog _state(){
      var msg =  message['state'];
      if(msg == 'REJECTED'){
        return StateDialog.REJECTED;
      }if(msg == 'PROPOSED'){
        return StateDialog.PROPOSED;
      }if(msg == 'OTW'){
        return StateDialog.OTW;
      }if(msg == "ARRIVED"){
        return StateDialog.ARRIVED;
      }if(msg == 'TRANSACTION_FINISHED'){
        return StateDialog.FINISHED;
      }else{
        return StateDialog.NONE;
      }
    }

    switch (_state()){
      case StateDialog.REJECTED:
        break;
      case StateDialog.PROPOSED:
        Dialogs.orderConfirm(_repositoryRemote);
        break;
      case StateDialog.OTW:
        Dialogs.otw(_repositoryRemote);
        break;
      case StateDialog.ARRIVED:
        Dialogs.arrived(_repositoryRemote);
        break;
      case StateDialog.FINISHED:
        Dialogs.finished(message, _repositoryRemote, user);
        break;
      default:
        break;
    }

  }
}
