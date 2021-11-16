import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/data/services/helper_controller.dart';

class WelcomeController extends GetxController{
  final formKeyLogin = GlobalKey<FormState>(debugLabel: 'login');
  final formKeyRegister = GlobalKey<FormState>(debugLabel: 'register');
  final formKeyReset = GlobalKey<FormState>(debugLabel: 'reset');
  TextEditingController emailC = TextEditingController();
  TextEditingController resetEmailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController nameC = TextEditingController();

  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  final HelperController _helper = Get.find<HelperController>();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void register() {
    isLoading.value = true;
    try{
      _repositoryRemote.registerAuth(
        nameC.text,
        emailC.text,
        passC.text,
      );
      isLoading.value = false;
    }catch (e){
      print('Email: ' + e.toString());
    }
  }

  void loginAuth(){
    isLoading.value = true;
    try{
      _repositoryRemote.loginAuth(emailC.text, passC.text,);
      isLoading.value = false;
    }catch (e){
      print('Email: ' + e.toString());
    }
  }

  void loginGoogle(){
    isLoading.value = true;
    try{
      _repositoryRemote.loginWithGoogle();
      isLoading.value = false;
    }catch (e){
      print('Email: ' + e.toString());
    }
  }

  void resetPassword(){
    isLoading.value = true;
    try{
      _repositoryRemote.resetPassword(resetEmailC.text);
      isLoading.value = false;
    }catch(e){
      print('reset : ${e.toString()}');
    }
  }

  Future _resetFields() async {
    nameC.text = '';
    emailC.text = '';
    passC.text = '';
  }

  init() async {
    isLoading.value = false;
    _resetFields();
  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    nameC.dispose();
    super.dispose();
  }

  @override
  void onReady(){
    _helper.connectivitySubscription.onData((data) {
      if(data == ConnectivityResult.none){
        Get.defaultDialog(
            title: 'Tidak ada koneksi internet',
            middleText: 'Aktifkan koneksi anda !',
            textConfirm: 'Ok',
            onConfirm: Get.back
        );
      }
    });
    super.onReady();
  }
}