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
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/modules/home/controllers/home_controller.dart';
import 'package:kakikeenam/app/modules/maps_location/views/components/bottom_sheet/loading_vendor.dart';
import 'package:kakikeenam/app/modules/maps_location/views/components/bottom_sheet/widget_modal.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';
import 'package:kakikeenam/app/utils/maps_style.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MapsLocationController extends GetxController {
  final HomeController _home = Get.find<HomeController>();
  var allMarker = MarkersModel().obs;
  var nearMarker = MarkersModel().obs;

  // for marker model
  List<dynamic> coordinate = List<dynamic>.empty(growable: true);
  List<dynamic> street = List<dynamic>.empty(growable: true);
  List<dynamic> id = List<dynamic>.empty(growable: true);
  List<dynamic> markersID = List<dynamic>.empty(growable: true);
  List<dynamic> vendorName = List<dynamic>.empty(growable: true);
  List<dynamic> vendorImage = List<dynamic>.empty(growable: true);
  List<dynamic> vendorEmail = List<dynamic>.empty(growable: true);
  GeoPoint? lastLocationData;

  FirebaseFirestore _dbStore = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;
  Completer<GoogleMapController> mController = Completer();
  GoogleMapController? mapController;

  GeolocatorPlatform locator = GeolocatorPlatform.instance;

  // custom marker
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor? buyerIcon;
  BitmapDescriptor? vendorIcon;

  // current location
  // Position? currentLocation;
  GeolocatorPlatform geoLocator = GeolocatorPlatform.instance;
  Rxn<Position> streamPosition = Rxn<Position>();

  bool ripple = true;

  String itemMarker = "";

  // dialog
  RxBool isDismissibleDialog = false.obs;
  RxBool isLoadingDismiss = true.obs;
  RxBool isDismissibleMarker = true.obs;

  UserModel get user => this._home.user;

  @override
  void onClose() async {
    var controller = await mController.future;
    controller.dispose();
    ripple = false;
    super.onClose();
  }

  @override
  void onInit() {
    streamPosition.bindStream(streamLocation());
    restartMarkerMap();
    super.onInit();
  }

  Stream<Position> streamLocation() {
    return locator.getPositionStream();
  }

  ///
  List<double> setNearestLocation() {
    List<double> _listNear = List<double>.empty(growable: true);
    final myLocation = ILatLng.point(
      streamPosition.value!.latitude,
      streamPosition.value!.longitude,
    );

    for (var i = 0; i < vendorName.length; i++) {
      final toMarkers = ILatLng.point(
        coordinate[i].latitude,
        coordinate[i].longitude,
      );
      double distance =
          SphericalUtil.computeDistanceBetween(myLocation, toMarkers) /
              Constants.MARKER_RADIUS;
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
          center: streamPosition.value != null
              ? LatLng(streamPosition.value!.latitude, streamPosition.value!.longitude)
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
    final users = _dbStore
        .collection(Constants.VENDOR)
        .where(Constants.STATUS_QUERY, isEqualTo: Constants.ONLINE)
        .snapshots();
    return users;
  }

  /// This function is for set data from vendors firestore database.
  /// And it will store to list [markersID] and [coordinate].
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
        coordinate.add(LatLng(latLng.latitude, latLng.longitude));
      });
      name?.forEach((name) {
        vendorName.add(name);
      });
      image?.forEach((img) {
        vendorImage.add(img);
      });
      coordinate.forEach((coordinate) {
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
    var pinPosition = streamPosition.value ??
        Position(
          longitude: -8.582572687412386,
          latitude: 116.1013248977757,
          timestamp: DateTime(3),
          accuracy: 1.1,
          altitude: 1.1,
          heading: 1.1,
          speed: 1.1,
          speedAccuracy: 1.1,
        );
    var pinLocation = LatLng(pinPosition.latitude, pinPosition.longitude);

      if (isDismissibleDialog.value) {
        markers[markerId] = RippleMarker(
          markerId: markerId,
          icon: buyerIcon ?? BitmapDescriptor.defaultMarker,
          position: pinLocation,
          ripple: ripple,
        );
        justNearestVendor();
      } else {
        allVendorMarker();
      }

    update();
  }

  void allVendorMarker() {
    var _markerList = allMarker.value.markersList;

    if (isDismissibleMarker.value && _markerList != null) {
      for (var i = 0; i < _markerList.length; i++) {
        markers[_markerList[i].markerId!] = Marker(
          markerId: _markerList[i].markerId!,
          icon: vendorIcon!,
          position: _markerList[i].latLng!,
        );
      }
    } else {
      _markerList?.removeRange(0, _markerList.length);
    }
  }

  void justNearestVendor() {
    var _markerList = nearMarker.value.markersList;
    if(_markerList != null){
      for (var i = 0; i < _markerList.length; i++) {
        markers[_markerList[i].markerId!] = Marker(
          markerId: _markerList[i].markerId!,
          icon: vendorIcon!,
          position: _markerList[i].latLng!,
        );
      }
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
          distance: _listNear[i],
          latLng: coordinate[i],
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
          latLng: coordinate[i],
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

  /// This function will pont camera to current position.
  /// and it will get last location that can store to firestore
  void getLastLocation() async {
    try {
      final users = _dbStore.collection(Constants.BUYER);
      var currentPosition = await geoLocator.getCurrentPosition();
      await users.doc(_auth.currentUser!.uid).update({
        "lastLocation": GeoPoint(
          currentPosition.latitude,
          currentPosition.longitude,
        )
      });
      getNearVendorMarker();
      myLocation();
      update();
    } catch (e) {}
  }

  void myLocation() async {
    final GoogleMapController _controller = await mController.future;
    final currentLocation = await geoLocator.getCurrentPosition();
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
    restartMarkerMap();
  }

  void mapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyles);
    mapController = controller;
    mController.complete(controller);
    setCustomMaker();
  }

  void itemMarkerAnimation(int index) {
    var _markerList = nearMarker.value.markersList;
    var initPosition = CameraPosition(target: Constants.SOURCE_LOCATION);
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
