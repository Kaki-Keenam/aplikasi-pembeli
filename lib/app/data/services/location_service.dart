import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class LocationController extends GetxController {
  final GeolocatorPlatform _locator = GeolocatorPlatform.instance;
  final box = GetStorage();
  StreamSubscription<Position>? _positionStreamSubscription;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;


  Rxn<Position>? streamPosition;
  var statusStream = false.obs;

  @override
  void onReady(){
    var isStatus = box.read('location');
    if(isStatus){
      toggleListening();
    }
    Future.delayed(Duration(seconds: 4), (){
      getLocationPermission();
    });
    super.onReady();
  }

  Future<void> getLocationPermission() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }
    var currentPosition = await _locator.getCurrentPosition();
    addToFirebase(currentPosition);
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _locator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _locator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _locator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }

    return true;
  }


  Future<void> toggleListening() async {
    if (_positionStreamSubscription == null) {
      final positionStream =
          await _locator.getPositionStream(timeInterval: 15);
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) {
        streamPosition?.value = position;
          addToFirebase(position);

      });
      _positionStreamSubscription?.pause();
    }

    if (_positionStreamSubscription == null) {
      return;
    }

    if (_positionStreamSubscription!.isPaused) {
      _positionStreamSubscription!.resume();
      statusStream.value = true;

    } else {
      _positionStreamSubscription!.pause();
      statusStream.value = false;
    }
  }

  Future<void> addToFirebase(Position stream) async {
    try {
      CollectionReference users = _db.collection(Constants.BUYER);
      User _currentUser = _auth.currentUser!;

      await users.doc(_currentUser.uid).update({
        "lastLocation": GeoPoint(
          stream.latitude,
          stream.longitude,
        ),
      });
    } catch (e) {
      print("location service: ${e.toString()}");
    }
  }

  @override
  void onClose() {
    _positionStreamSubscription?.cancel();
    super.onClose();
  }
}
