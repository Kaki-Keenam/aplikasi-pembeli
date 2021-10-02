import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void loginSuccess() {
    Get.snackbar(
      "Berhasil",
      "Login Berhasil",
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      showProgressIndicator: true,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
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
      textConfirm: "Hide"
    );
  }

  void arrivedDialog({VoidCallback? func}) {
    Get.defaultDialog(
        title: "Pedagang sudah samapai",
        barrierDismissible: false,
        content: Text("Silahkan melakukan transaksi ! \nJika sudah klik transaksi berhasil"),
        onConfirm: func,
        textConfirm: "Berhasil"
    );
  }
}
