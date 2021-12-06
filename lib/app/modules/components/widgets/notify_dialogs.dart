import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kakikeenam/app/data/models/review_model.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:lottie/lottie.dart';

class NotifyDialogs {
  void verifyDialog() {
    Get.defaultDialog(
      title: "Email verifiaksi terkirim",
      middleText: "Kami telah mengirimkan email verifikasi",
      onConfirm: () {
        Get.back();
        Get.back();
      },
      textConfirm: "Ya",
    );
  }

  void repeatVerifyDialog({VoidCallback? func}) async {
    Get.defaultDialog(
      title: "Verifikasi Email",
      middleText:
          "Perlu melakukan verifiakasi email dulu. Apakah anda ingin melakukan verifikasi ? ",
      onConfirm: func,
      textConfirm: "Kirim Ulang",
      textCancel: "Kembali",
    );
  }

  void errorEmailDialog({VoidCallback? func}) {
    Get.defaultDialog(
      title: "Terjadi Kesalahan",
      middleText: "Email sudah digunakan",
      onConfirm: func,
      textConfirm: "Ok",
    );
  }

  void errorDialog(String error) {
    Get.snackbar(
      "Kesalahan",
      "$error",
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
    );
  }

  void emailNotFoundDialog() {
    Get.defaultDialog(
      title: "Akun tidak ditemukan",
      middleText: "Silahkan melakukan pendaftaran",
    );
  }

  void wrongPasswordDialog() {
    Get.snackbar(
      "Password Salah",
      "Terjadi kesalahan password",
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
    );
  }

  void loadingDialog() {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 150,
            width: 150,
            child: Lottie.asset('assets/animation/loading.zip',
                width: 140, height: 140, fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }

  void editSuccess() {
    Get.defaultDialog(
      title: "Berhasil",
      middleText: "Edit Profile berhasil",
      onConfirm: () => Get.back(),
      textConfirm: "Ok",
    );
  }

  void noInternetConnection({VoidCallback? confirm}) {
    Get.defaultDialog(
      title: "Masalah Koneksi",
      middleText: "Tidak ada koneksi saat ini!",
      onConfirm: confirm,
      barrierDismissible: false,
      textConfirm: "Ok",
    );
  }

  void resetPasswordDialog() {
    Get.defaultDialog(
        title: "Reset password telah terkirim",
        middleText: "Silahkan periksa email anda",
        onConfirm: () {
          Get.back();
          Get.back();
        },
        textConfirm: "Ok");
  }

  void logoutDialog({VoidCallback? func}) {
    Get.defaultDialog(
      title: "Logout Akun",
      barrierDismissible: false,
      content: Text("Apakah anda yakin ingin logout ?"),
      onConfirm: func,
      textConfirm: "Ya",
      textCancel: "Tidak",
    );
  }

  void exitDialog({VoidCallback? func}) {
    Get.defaultDialog(
      title: "Keluar Aplikasi",
      barrierDismissible: false,
      content: Text("Apakah anda yakin ingin keluar ?"),
      onConfirm: func,
      textConfirm: "Ya",
      textCancel: "Tidak",
    );
  }

  void otw(RepositoryRemote repository) {
      repository.futureListTrans().then((value) {
        TransactionModel trans = TransactionModel.fromDocument(
            value.docs[0].data() as Map<String, dynamic>);
        Get.snackbar(
          '${trans.storeName} dalam perjalanan',
          'Silahkan menunggu. pedagang sedang menuju lokasi anda !',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      });
  }

  void arrived(RepositoryRemote repository) {
    repository.futureListTrans().then((value) {
      TransactionModel trans = TransactionModel.fromDocument(
          value.docs[0].data() as Map<String, dynamic>);
      Get.snackbar(
        '${trans.storeName} Sudah Sampai',
        'Pedagang sudah sampai, segera selesaikan transaksi Anda !',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
  }

  void finished(dynamic message, RepositoryRemote repository, UserModel? user) {
    var state = message['state'];
    List<Review> _review = List.empty(growable: true);
    Get.bottomSheet(
      Container(
        height: Get.height * 0.3,
        child: Stack(
          children: [
            Container(
              height: 50,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.amber[600],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Berikan Penilaian Pedagang',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 50,
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
                      repository.futureListTrans().then((value) {
                        TransactionModel trans = TransactionModel.fromDocument(
                            value.docs[0].data() as Map<String, dynamic>);
                        var review = Review()
                          ..vendorId = trans.vendorId
                          ..buyerId = trans.buyerId
                          ..buyerName = trans.buyerName
                          ..buyerImage = user?.photoUrl
                          ..rating = rating;
                        repository.updateTrans(trans.transactionId!, state, rating);
                        _review.add(review);
                      });
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                              repository.addReview(_review.last);
                              _review.clear();
                              Get.back();
                              if(Get.isBottomSheetOpen == true){
                                Get.back();
                              }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green,
                            ),
                            child: Center(
                              child: Text(
                                'Terimakasih',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      isDismissible: false,
      elevation: 20.0,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
    );
  }

  void orderConfirm(RepositoryRemote repository) {
    repository.futureListTrans().then((value) {
      var trans = TransactionModel.fromDocument(
          value.docs[0].data() as Map<String, dynamic>);
      Get.bottomSheet(
        Container(
          height: Get.height * 0.4,
          child: Stack(
            children: [
              Container(
                height: 50,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.amber[600],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Menunggu Pedagang',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Detail Pesanan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nama',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${trans.product?[0].name}',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Harga',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${NumberFormat.currency(
                            name: "id",
                            decimalDigits: 0,
                            symbol: "Rp",
                          ).format(trans.product?[0].price)}',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: Get.height * 0.1,
                          width: Get.height * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: trans.product?[0].image != null
                                ? CachedNetworkImage(
                                    imageUrl: "${trans.product?[0].image}",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Transform.scale(
                                      scale: 0.5,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Icon(Icons.error),
                          ),
                        ),
                        Text('X 1')
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              repository.futureListTrans().then((value) {
                                var currentTransId =
                                    value.docs[0].get('transactionId');
                                repository.updateTrans(
                                    currentTransId, "REJECTED");
                              });
                              Get.back();
                              if(Get.isBottomSheetOpen == true){
                                Get.back();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Text(
                                  'Batalkan',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.back();
                              if(Get.isBottomSheetOpen == true){
                                Get.back();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.green,
                              ),
                              child: Center(
                                child: Text(
                                  'Lanjutkan',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        isDismissible: false,
        elevation: 20.0,
        enableDrag: false,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
      );
    });
  }
}
