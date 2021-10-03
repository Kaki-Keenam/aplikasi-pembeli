import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class LocationController extends GetxController {
  final GeolocatorPlatform geolocatorAndroid = GeolocatorPlatform.instance;
  StreamSubscription<Position>? _positionStreamSubscription;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  // StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;

  Rxn<List<VendorModel>> _vendorModel = Rxn<List<VendorModel>>();

  List<VendorModel>? get vendors => _vendorModel.value;

  Rxn<Position>? streamPosition;
  var statusStream = false.obs;

  @override
  void onReady(){
    getLocationPermission();
    super.onReady();
  }

  Future<void> getLocationPermission() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geolocatorAndroid.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await geolocatorAndroid.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocatorAndroid.requestPermission();
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
          await geolocatorAndroid.getPositionStream(timeInterval: 15);
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
      CollectionReference users = _firestore.collection(Constants.BUYER);
      User _currentUser = _auth.currentUser!;

      await users.doc(_currentUser.email).update({
        "lastLocation": GeoPoint(
          stream.latitude,
          stream.longitude,
        ),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void onClose() {
    _positionStreamSubscription!.cancel();
    super.onClose();
  }
}
