import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/data/services/helper_controller.dart';

class WelcomeController extends GetxController{
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController nameC = TextEditingController();

  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();

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
    }catch (e){
      print('Email: ' + e.toString());
    }
  }

  void loginAuth(){
    isLoading.value = true;
    try{
      _repositoryRemote.loginAuth(emailC.text, passC.text,);
    }catch (e){
      print('Email: ' + e.toString());
    }
  }

  void loginGoogle(){
    isLoading.value = true;
    try{
      _repositoryRemote.loginWithGoogle();
    }catch (e){
      print('Email: ' + e.toString());
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
}