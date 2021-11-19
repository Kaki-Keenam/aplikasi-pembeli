
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/review_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class Fcm {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();

  Future<void> initFirebaseMessaging({
     String? userId,
  }) async {
    try {
      print('INIT FIREBASE MESSAGING');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print('ON MESSAGE');
        if (!kReleaseMode) print('onMessage: ${message.data}');

        handleMessage(message.data);
      });
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
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
      print('userId ${userId}');
      users
          .doc(userId)
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

  void handleMessage(Map<String, dynamic> message) {
    if (message['state'] == 'PROPOSED') {
      Get.defaultDialog(
          title: 'Pesanan dikirim',
          middleText: 'Menunggu konfirmasi pesanan',
          textConfirm: 'Ok',
          onConfirm: () {
            if (Get.isDialogOpen == true) {
              Get.back();
            }
          },
          textCancel: 'Batalkan',
          onCancel: () {
            _repositoryRemote.futureListTrans().then((value) {
              var currentTransId =
              value.docs[0].get('transactionId');
              _repositoryRemote.updateTrans(currentTransId, "REJECTED");
            });
          });
    } else if (message['state'] == 'REJECTED') {
      Get.defaultDialog(
          title: 'Pesanan anda dibatalkan',
          middleText: 'Anda tidak bisa melanjukan transaksi saat ini. Silahkan coba lagi nanti!',
          textConfirm: 'Ok',
          onConfirm: () {
            if (Get.isDialogOpen == true) {
              Get.back();
            }
          });
    } else if (message['state'] == 'OTW') {
      Get.defaultDialog(
          title: 'Pesanan diterima penjual',
          middleText: 'Silahkan menunggu penjual sampai di lokasi anda',
          textConfirm: 'Ok',
          onConfirm: () {
            if (Get.isDialogOpen == true) {
              Get.back();
            }
          });
    } else if (message['state'] == 'ARRIVED') {
      Get.defaultDialog(
          title: 'Penjual sudah sampai dilokasi anda',
          middleText: 'Silahkan melakukan transaksi dengan penjual',
          textConfirm: 'Ok',
          onConfirm: () {
            if (Get.isDialogOpen == true) {
              Get.back();
            }
          });
    } else if (message['state'] == 'TRANSACTION_FINISHED') {
      var state = message['state'];
      Get.defaultDialog(
          title: 'Terimakasi sudah melakukan transaksi',
          titleStyle: TextStyle(fontSize: 18),
          titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          content: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: Column(
              children: [
                Text('Berikan penilaian untuk pedagang'),
                SizedBox(
                  height: 15,
                ),
                RatingBar.builder(
                  minRating: 1,
                  itemSize: 40,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.orangeAccent,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                    _repositoryRemote.futureListTrans().then((value) {
                      var currentTransId = value.docs[0].data() as Map<String, dynamic>;
                      var transId = currentTransId['transactionId'];
                      var review = Review()
                      ..vendorId = currentTransId['vendorId']
                      ..buyerId = currentTransId['buyerId']
                        ..buyerName = currentTransId['buyerName']
                      ..rating = rating;

                      _repositoryRemote.updateTrans(transId, state, rating);

                      _repositoryRemote.addReview(review);
                    });
                  },
                )
              ],
            ),
          ),
          textConfirm: 'Ok',
          onConfirm: () {
            if (Get.isDialogOpen == true) {
              Get.back();
            }
          });
    }
  }
}
