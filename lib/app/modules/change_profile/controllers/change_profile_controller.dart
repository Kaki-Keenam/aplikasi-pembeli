import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfileController extends GetxController {
  var emailC = TextEditingController();
  var nameC = TextEditingController();
  var loading = false.obs;
  ImagePicker imagePicker = ImagePicker();
  FirebaseStorage _storage = FirebaseStorage.instance;

  XFile? pickerImage;

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

  @override
  void onClose() {
    emailC.dispose();
    nameC.dispose();
    super.onClose();
  }
}
