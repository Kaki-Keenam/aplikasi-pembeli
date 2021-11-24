import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/data/services/helper_controller.dart';
import 'package:kakikeenam/app/data/services/location_service.dart';
import 'package:kakikeenam/app/utils/utils.dart';

class WelcomeController extends GetxController{
  final formKeyLogin = GlobalKey<FormState>(debugLabel: 'login');
  final formKeyRegister = GlobalKey<FormState>(debugLabel: 'register');
  final formKeyReset = GlobalKey<FormState>(debugLabel: 'reset');
  final LocationService _locationService = Get.find<LocationService>();
  TextEditingController emailC = TextEditingController();
  TextEditingController resetEmailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController nameC = TextEditingController();

  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  final HelperController _helper = Get.find<HelperController>();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getLocationPermission();
    init();
    super.onInit();
  }

  Future<void> getLocationPermission() async {
    await _locationService.getLocationPermission();
  }


  Future<void> register() async {

    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential _userSignup = await _auth.createUserWithEmailAndPassword(
        email: emailC.text,
        password: passC.text,
      );
      print('register: error');
      _repositoryRemote.addToFirebase(nameC.text);
      await _userSignup.user?.sendEmailVerification();

      Dialogs.verifyDialog();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Password terlalu lemah');
      } else if (e.code == 'email-already-in-use') {
        Dialogs.errorEmailDialog(
            func: () {
              Get.back();
            }
        );
      }
    } catch (e) {
      print('register : ${e.toString()}');
      Dialogs.errorDialog("Registrasi error");
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