import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/review_model.dart';
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
            child: Lottie.asset(
                'assets/animation/loading.zip',
                width: 140,
                height: 140,
                fit: BoxFit.fill
            ),
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

  void proposedDialog({VoidCallback? func}) {
    Get.defaultDialog(
        title: "Menunggu Konfirmasi",
        barrierDismissible: false,
        content: CircularProgressIndicator(),
        onCancel: func,
        onConfirm: () => Get.back(),
        textConfirm: "Hide");
  }

  void arrivedDialog({VoidCallback? func}) {
    Get.defaultDialog(
        title: "Pedagang sudah samapai",
        barrierDismissible: false,
        content: Text(
            "Silahkan melakukan transaksi ! \nJika sudah klik transaksi berhasil"),
        onConfirm: func,
        textConfirm: "Berhasil");
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

  void proposed(RepositoryRemote repository){
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
          repository.futureListTrans().then((value) {
            var currentTransId = value.docs[0].get('transactionId');
            repository.updateTrans(currentTransId, "REJECTED");
          });
        });
  }

  void rejected(){
    Get.defaultDialog(
        title: 'Pesanan anda dibatalkan',
        middleText:
        'Anda tidak bisa melanjukan transaksi saat ini. Silahkan coba lagi nanti!',
        textConfirm: 'Ok',
        onConfirm: () {
          if (Get.isDialogOpen == true) {
            Get.back();
          }
        });
  }

  void otw(){
    Get.defaultDialog(
        title: 'Pesanan diterima penjual',
        middleText: 'Silahkan menunggu penjual sampai di lokasi anda',
        textConfirm: 'Ok',
        onConfirm: () {
          if (Get.isDialogOpen == true) {
            Get.back();
          }
        });
  }

  void arrived(){
    Get.defaultDialog(
        title: 'Penjual sudah sampai dilokasi anda',
        middleText: 'Silahkan melakukan transaksi dengan penjual',
        textConfirm: 'Ok',
        onConfirm: () {
          if (Get.isDialogOpen == true) {
            Get.back();
          }
        });
  }

  void finished(dynamic message, RepositoryRemote repository, UserModel? user){
    var state = message['state'];
    List<Review> _review = List.empty(growable: true);
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
                  repository.futureListTrans().then((value) {
                    var currentTransId =
                    value.docs[0].data() as Map<String, dynamic>;
                    var transId = currentTransId['transactionId'];

                    var review = Review()
                      ..vendorId = currentTransId['vendorId']
                      ..buyerId = currentTransId['buyerId']
                      ..buyerName = currentTransId['buyerName']
                      ..buyerImage = user?.photoUrl
                      ..rating = rating;

                    repository.updateTrans(transId, state, rating);
                    _review.add(review);
                  });
                },
              )
            ],
          ),
        ),
        textConfirm: 'Ok',
        onConfirm: () {
          if (Get.isDialogOpen == true) {
            repository.addReview(_review.last);
            _review.clear();
            Get.back();
          }
        });
  }
}
