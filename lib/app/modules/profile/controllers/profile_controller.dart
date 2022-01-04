import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';

class ProfileController extends GetxController {
  final formKeyName = GlobalKey<FormState>(debugLabel: 'editName');
  final TextEditingController nameEditC = TextEditingController();

  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();

  RxBool loading = false.obs;
  ImagePicker imagePicker = ImagePicker();
  FirebaseStorage _storage = FirebaseStorage.instance;

  XFile? pickerImage;

  var _user = UserModel().obs;

  UserModel get user => this._user.value;

  Future<void> selectedImage() async {
    try{
      final checkImage = await imagePicker.pickImage(source: ImageSource.gallery);
      if(checkImage != null){
        pickerImage = checkImage;
      }
      update();
    }catch(e){
      pickerImage = null;
      update();
    }
  }

  Future<void> resetImage() async {
    pickerImage = null;
    update();
  }

  Future<String> uploadImage(String? uid) async {
    loading.value = true;
    Reference _storageRef = _storage.ref("profile/$uid.png");
    File _file = File(pickerImage?.path ?? "");

    try {
      await _storageRef.putFile(_file);
      final photoUrl = await _storageRef.getDownloadURL();
      loading.value = false;
      resetImage();
      return photoUrl;
    }catch (e){
      return "";
    }
  }

  void logout() {
      _repositoryRemote.logout();
      loading.value = false;
  }

  void editName(String name){
    try{
      _repositoryRemote.editName(name);
    }catch (e){
      print("editName: ${e.toString()}");
    }
  }

  void updatePhoto(String url){
    try{
      _repositoryRemote.updatePhoto(url);
    }catch (e){
      print("updatePhoto: ${e.toString()}");
    }
  }

  @override
  void onClose() {
    nameEditC.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    _user.bindStream(_repositoryRemote.userModel);
    super.onInit();
  }
}
