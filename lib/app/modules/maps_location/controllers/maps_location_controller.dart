import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/core/i_lat_lng.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:flutter_animarker/helpers/spherical_util.dart';
import 'package:geocoding/geocoding.dart' as Geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kakikeenam/app/data/models/markers_model.dart';
import 'package:kakikeenam/app/modules/maps_location/views/components/bottom_sheet/loading_vendor.dart';
import 'package:kakikeenam/app/modules/maps_location/views/components/bottom_sheet/widget_modal.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';
import 'package:kakikeenam/app/utils/maps_style.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MapsLocationController extends GetxController {
  var allMarker = MarkersModel().obs;
  var nearMarker = MarkersModel().obs;

  // for marker model
  List<dynamic> coordVendor = List<dynamic>.empty(growable: true);
  List<dynamic> street = List<dynamic>.empty(growable: true);
  List<dynamic> id = List<dynamic>.empty(growable: true);
  List<dynamic> markersID = List<dynamic>.empty(growable: true);
  List<dynamic> vendorName = List<dynamic>.empty(growable: true);
  List<dynamic> vendorImage = List<dynamic>.empty(growable: true);
  List<dynamic> vendorEmail = List<dynamic>.empty(growable: true);
  GeoPoint? lastLocationData;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Completer<GoogleMapController> mController = Completer();
  GoogleMapController? mapController;
  // Location location = Location();

  // custom marker
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor? buyerIcon;
  BitmapDescriptor? vendorIcon;
  QueryDocumentSnapshot<Object?>? dataVendor;

  // current location
  // Position? currentLocation;
  GeolocatorPlatform geolocatorAndroid = GeolocatorPlatform.instance;
  Position? streamPosition;

  bool ripple = true;

  String itemMarker = "";

  // dialog
  RxBool isDismissibleDialog = false.obs;
  RxBool isLoadingDismiss = false.obs;
  RxBool isDismissibleMarker = true.obs;

  @override
  void onClose() async {
    var controller = await mController.future;
    controller.dispose();
    streamPosition = null;
    ripple = false;
    super.onClose();
  }

  @override
  onInit(){
    getCurrentPosition();
    Timer.periodic(Duration(seconds: 3), (timer) {
      restartMarkerMap();
    });
    super.onInit();
  }

  /// this set for last location of user.
  /// when user use map to find vendor
  /// and this will add to firestore with current account
  set setLastLocation(GeoPoint lastLocation) {
    lastLocationData = lastLocation;
  }

  set positionStream(Position position) => this.streamPosition = position;

  /// This is function for firs initial camera position
  CameraPosition initPosition = CameraPosition(
    zoom: Constants.CAMERA_ZOOM_INIT,
    tilt: Constants.CAMERA_TILT,
    bearing: Constants.CAMERA_BEARING,
    target: Constants.SOURCE_LOCATION,
  );

  ///
  List<double> setNearestLocation() {
    List<double> _listNear = List<double>.empty(growable: true);
    final myLocation = ILatLng.point(
      streamPosition!.latitude,
      streamPosition!.longitude,
    );

    for (var i = 0; i < vendorName.length; i++) {
      final toMarkers = ILatLng.point(
        coordVendor[i].latitude,
        coordVendor[i].longitude,
      );
      double distance =
          SphericalUtil.computeDistanceBetween(myLocation, toMarkers) / 1000.0;
      _listNear.add(distance);
    }
    return _listNear;
  }

  /// This function for create circle center of current location.
  ///
  /// This will return [Set<Circle>]
  /// and will use in [maps_location_view.dart].
  Set<Circle> setCircleLocation() {
    Set<Circle> circle = Set.from([
      Circle(
          circleId: CircleId(Constants.MY_LOCATION_ID),
          center: streamPosition != null
              ? LatLng(streamPosition!.latitude, streamPosition!.longitude)
              : Constants.SOURCE_LOCATION,
          radius: Constants.CIRCLE_RADIUS,
          fillColor: Color.fromRGBO(251, 221, 50, 0.12),
          strokeWidth: 2,
          strokeColor: Colors.amber)
    ]);
    update();
    return circle;
  }

  /// This function for avoid null value of [setCircleLocation].
  /// if [setCircleLocation] null, it will return
  Set<Circle> blankCircleLocation() {
    Set<Circle> circle = Set.from([
      Circle(
        circleId: CircleId(Constants.MY_LOCATION_ID),
      )
    ]);
    return circle;
  }

  /// This function for get data stream from all vendors.
  Stream<QuerySnapshot<Object?>> addLatLangMarkers() {
    // var currentLoc = Get.find<LocationController>().currentLoc;
    // final distanceInMile = 1;
    // final lat = 0.0144927536231884;
    // final lon = 0.0181818181818182;
    //
    // final greaterLat = cu!.latitude! + (lat * distanceInMile);
    // final greaterLong = currentLoc.longitude! + (lon * distanceInMile);
    // final greaterGeoPoint = GeoPoint(greaterLat, greaterLong);
    final users = _firestore
        .collection(Constants.VENDOR)
    // .where("position", isLessThanOrEqualTo: greaterGeoPoint)
        .snapshots();
    return users;
  }

  /// This function is for set data from vendors firestore database.
  /// And it will store to list [markersID] and [coordVendor].
  void setDataVendor({
    Iterable<dynamic>? marker,
    Iterable<dynamic>? latLng,
    Iterable<dynamic>? name,
    Iterable<dynamic>? image,
  }) {
    try {
      marker?.forEach((mark) {
        markersID.add(MarkerId(mark));
      });
      marker?.forEach((idMarker) {
        id.add(idMarker);
      });
      latLng?.forEach((latLng) {
        coordVendor.add(LatLng(latLng.latitude, latLng.longitude));
      });
      name?.forEach((name) {
        vendorName.add(name);
      });
      image?.forEach((img) {
        vendorImage.add(img);
      });
      coordVendor.forEach((coordinate) {
        Geo.placemarkFromCoordinates(coordinate.latitude, coordinate.longitude)
            .then((value) => street
            .add("${value.first.street}, ${value.first.subLocality}"));
      });
      getAllVendorMarker();
    } catch (e) {
      print(e.toString());
    }
  }

  /// This function for setup custom marker.
  /// Marker for Buyer [buyerIcon] and Vendor [vendorIcon]
  void setCustomMaker() async {
    await getBytesFromAsset(Constants.BUYER_MARKER, 64).then((onValue) {
      buyerIcon = BitmapDescriptor.fromBytes(onValue);
    });
    await getBytesFromAsset(Constants.VENDOR_MARKER, 64).then((onValue) {
      vendorIcon = BitmapDescriptor.fromBytes(onValue);
    });
    update();
  }

  /// This function for get marker from png
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    update();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  /// This function is for restart marker every time
  /// buyer move from their position
  void restartMarkerMap() async {
    var markerId = MarkerId(Constants.MY_LOCATION_ID);
    var currentPosition = await geolocatorAndroid.getCurrentPosition();
    var pinPosition =
    LatLng(currentPosition.latitude, currentPosition.longitude);
    try {
      markers.removeWhere(
              (_, id) => id.markerId.value == Constants.MY_LOCATION_ID);
      if (isDismissibleDialog.value) {
        markers[markerId] = RippleMarker(
          markerId: markerId,
          icon: buyerIcon ?? BitmapDescriptor.defaultMarker,
          position: pinPosition,
          ripple: ripple,
        );
        justNearestVendor();
      } else {
        allVendorMarker();
      }
    } catch (e) {
      print(e.toString());
    }
    update();
  }

  void allVendorMarker() {
    var _markerList = allMarker.value.markersList!;

    if (isDismissibleMarker.value) {
      for (var i = 0; i < _markerList.length; i++) {
        markers[_markerList[i].markerId!] = Marker(
          markerId: _markerList[i].markerId!,
          icon: vendorIcon!,
          position: _markerList[i].latLng!,
        );
      }
    } else {
      _markerList.removeRange(0, _markerList.length);
    }
  }

  void justNearestVendor() {
    var _markerList = nearMarker.value.markersList!;
    for (var i = 0; i < _markerList.length; i++) {
      markers[_markerList[i].markerId!] = Marker(
        markerId: _markerList[i].markerId!,
        icon: vendorIcon!,
        position: _markerList[i].latLng!,
      );
    }
  }

  /// This function is for show all nearest marker
  /// around 1 km distance
  void getNearVendorMarker() {
    List<Markers> listNear = List<Markers>.empty(growable: true);
    var _listNear = setNearestLocation();
    for (var i = 0; i < _listNear.length; i++) {
      if (_listNear[i] < Constants.NEARBY) {
        listNear.add(Markers(
          id: id[i],
          name: vendorName[i],
          markerId: markersID[i],
          latLng: coordVendor[i],
          street: street[i],
          image: vendorImage[i],
        ));
      }
    }
    nearMarker.update((marker) {
      marker?.markersList = listNear;
    });
    nearMarker.refresh();
  }

  void getAllVendorMarker() {
    List<Markers> markersList = List<Markers>.empty(growable: true);
    try {
      for (var i = 0; i < vendorName.length; i++) {
        markersList.add(Markers(
          id: id[i],
          name: vendorName[i],
          markerId: markersID[i],
          latLng: coordVendor[i],
          image: vendorImage[i],
        ));
      }
      allMarker.update((marker) {
        marker?.markersList = markersList;
      });
      allMarker.refresh();
    } catch (e) {
      print(e.toString());
    }
  }

  /// This function to setting listener realtime location
  /// every buyer move from their position
  Future<void> getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }
    positionStream = await
    geolocatorAndroid.getCurrentPosition();
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

  /// This function will pont camera to current position.
  /// and it will get last location that can store to firestore
  void getLastLocation() async {
    try {
      final users = _firestore.collection(Constants.BUYER);
      await users.doc(_auth.currentUser!.email).update({
        "lastLocation": GeoPoint(
          streamPosition!.latitude,
          streamPosition!.longitude,
        )
      });
      getNearVendorMarker();
      myLocation();
      update();
    } catch (e) {
    }
  }

  void myLocation() async {
    final GoogleMapController _controller = await mController.future;
    final currentLocation = await geolocatorAndroid.getCurrentPosition();
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: Constants.CAMERA_BEARING,
        target: LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        ),
        zoom: Constants.CAMERA_ZOOM_OUT,
      ),
    ));
  }

  void mapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyles);
    mapController = controller;
    mController.complete(controller);
    setCustomMaker();
  }

  void itemMarkerAnimation(int index) {
    var _markerList = nearMarker.value.markersList;
    if (_markerList?[index].latLng != null) {
      initPosition = CameraPosition(
        target: _markerList![index].latLng!,
        zoom: Constants.CAMERA_ZOOM_IN,
      );
    }
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(initPosition),
    );
  }

  /// This function is for show loading widget on map
  /// when buyer search vendor position around
  void loadingVendor(BuildContext context) {
    showFloatingBottom(
      context: context,
      builder: (context) => LoadingVendor(),
      dismissible: false,
    );
  }

  /// Function for setup widget dialog on google map
  Future<T?> showFloatingBottom<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    required bool dismissible,
  }) async {
    final result = await showCustomModalBottomSheet(
        context: context,
        builder: builder,
        elevation: 15,
        barrierColor: Colors.transparent,
        containerWidget: (_, animation, child) => WidgetModal(
          child: child,
        ),
        expand: false,
        isDismissible: dismissible,
        enableDrag: false,
        duration: Duration(milliseconds: 500));
    return result;
  }
}
