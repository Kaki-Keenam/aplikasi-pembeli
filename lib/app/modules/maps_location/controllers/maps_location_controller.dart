import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kakikeenam/app/data/models/markers_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/data/services/location_service.dart';
import 'package:kakikeenam/app/modules/home/controllers/home_controller.dart';
import 'package:kakikeenam/app/modules/maps_location/views/components/bottom_sheet/loading_vendor.dart';
import 'package:kakikeenam/app/modules/maps_location/views/components/bottom_sheet/widget_modal.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as tool;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MapsLocationController extends GetxController {
  final HomeController _home = Get.find<HomeController>();
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  final LocationService _locationService = Get.find<LocationService>();
  var mController = Rxn<GoogleMapController>();
  final mapController = Completer<GoogleMapController>();
  GeolocatorPlatform locator = GeolocatorPlatform.instance;
  GeocodingPlatform geoCoding = GeocodingPlatform.instance;

  RxMap markers = <MarkerId, Marker>{}.obs;
  RxBool mapLoading = true.obs;

  BitmapDescriptor? vendorMarker;
  BitmapDescriptor? buyerMarker;
  Timer? locationTimer;

  RxBool isDismissibleDialog = false.obs;
  RxBool isLoadingDismiss = false.obs;
  RxBool isDismissibleEmpty = false.obs;

  var userPosition = Rxn<Position>();
  var markerModel = RxList<Markers>();
  var itemVendor = RxList<Markers>();

  var indexItem = 0.obs;
  RxBool ripple = true.obs;

  @override
  void onInit() {
    markerModel.bindStream(getMarkerData());
    itemVendor.bindStream(getItemMarkerVendor());
    setCustomMaker();

    super.onInit();
  }

  @override
  void onReady() {
    getLocationPermission();
    locationTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      allVendors();
    });
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
    mController.close();
    locationTimer?.cancel();
    ripple.close();
  }

  Position? get user => this._home.mapPosition;

  set index(int index) => this.indexItem.value;

  set setMarker(BitmapDescriptor markers) => this.vendorMarker = markers;

  set setPosition(Position position) => this.userPosition.value = position;

  set setMapController(GoogleMapController mapController) =>
      this.mController.value = mapController;

  Future<String> getStreet(GeoPoint? location) async {
    List<Placemark> street = await geoCoding.placemarkFromCoordinates(
        location!.latitude, location.longitude);
    String streetValue = "${street.first.street} ${street.first.subLocality}";
    return streetValue;
  }

  Stream<List<Markers>> getMarkerData() {
    return _repositoryRemote.getVendorStreamQuery().map((QuerySnapshot query) {
      List<Markers> listData = List.empty(growable: true);
      query.docs.forEach((DocumentSnapshot doc) {
        var mark = doc.data() as Map<String, dynamic>;
        listData.add(Markers()
          ..id = mark["uid"]
          ..latLng = mark["lastLocation"]
          ..markerId = mark["uid"]
          ..rating = mark["rating"] / 1.0
          ..name = mark["storeName"]
          ..image = mark["storeImage"]);
      });
      return listData;
    });
  }

  // Distance settings
  Stream<List<Markers>> getItemMarkerVendor() {
    return _repositoryRemote.getVendorStreamQuery().map((QuerySnapshot query) {
      List<Markers> listData = List.empty(growable: true);
      for (var i = 0; i < query.docs.length; i++) {
        var mark = query.docs[i].data() as Map<String, dynamic>;
        if (distanceVendor()[i] < 750) {
          listData.add(Markers()
            ..id = mark["uid"]
            ..latLng = mark["lastLocation"]
            ..markerId = mark["uid"]
            ..rating = mark["rating"] / 1.0
            ..name = mark["storeName"]
            ..image = mark["storeImage"]
            ..distance = distanceVendor()[i]);
        }
      }
      return listData;
    });
  }

  Future setCustomMaker() async {
    await getBytesFromAsset('assets/images/merchant.png', 64).then((onValue) {
      setMarker = BitmapDescriptor.fromBytes(onValue);
    });
    await getBytesFromAsset('assets/images/marker.png', 64).then((onValue) {
      buyerMarker = BitmapDescriptor.fromBytes(onValue);
    });
  }

  Set<Circle> setCircleLocation() {
    Set<Circle> circle = Set.from([
      Circle(
          circleId: CircleId(Constants.MY_LOCATION_ID),
          center: LatLng(user!.latitude, user!.longitude),
          radius: Constants.CIRCLE_RADIUS,
          fillColor: Color.fromRGBO(251, 221, 50, 0.12),
          strokeWidth: 2,
          strokeColor: Colors.amber)
    ]);
    return circle;
  }

  Set<Circle> blankCircleLocation() {
    Set<Circle> circle = Set.from([
      Circle(
        circleId: CircleId(Constants.MY_LOCATION_ID),
      )
    ]);
    return circle;
  }

  void setBuyerMarker() {
    markers[MarkerId(Constants.BUYER_MARKER)] = RippleMarker(
      markerId: MarkerId(Constants.BUYER_MARKER),
      icon: buyerMarker ?? BitmapDescriptor.defaultMarker,
      position: LatLng(user!.latitude, user!.longitude),
      ripple: true,
    );
  }

  /// This function for get marker from png
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void allVendors() {
    if (markerModel.length != 0) {
      for (var i = 0; i < markerModel.length; i++) {
        markers[MarkerId(markerModel[i].markerId ?? "")] = Marker(
          markerId: MarkerId(markerModel[i].markerId ?? ""),
          icon: vendorMarker ?? BitmapDescriptor.defaultMarker,
          position: LatLng(
              markerModel[i].latLng?.latitude ?? -8.583453197331222,
              markerModel[i].latLng?.longitude ?? 116.10029494504296),
        );
      }
    }
  }

  Future<void> getLocationPermission() async {
    var currentPosition = await locator.getCurrentPosition();
    setPosition = currentPosition;
    await _locationService.getLocationPermission();
  }

  Future myLocation() async {
    mController.value?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: Constants.CAMERA_BEARING,
        target: LatLng(
          user?.latitude ?? -8.582572687412386,
          user?.longitude ?? 116.1013248977757,
        ),
        zoom: Constants.CAMERA_ZOOM_OUT,
      ),
    ));
  }

  void itemMarkerAnimation(int index) {
    if (markerModel[index].latLng != null) {
      print("index vendor ${markerModel[index].name}");
      var initPosition = CameraPosition(
        target: LatLng(markerModel[index].latLng!.latitude,
            markerModel[index].latLng!.longitude),
        zoom: Constants.CAMERA_ZOOM_IN,
      );
      mController.value?.animateCamera(
        CameraUpdate.newCameraPosition(initPosition),
      );
    }
  }

  List<double> distanceVendor() {
    List<double> listNearChallenge = List.empty(growable: true);
    for (var i = 0; i < markerModel.length; i++) {
      var distance = tool.SphericalUtil.computeDistanceBetween(
              tool.LatLng(user?.latitude ?? -8.582572687412386,
                  user?.longitude ?? 116.1013248977757),
              tool.LatLng(markerModel[i].latLng?.latitude ?? -8.582572687412386,
                  markerModel[i].latLng?.longitude ?? 116.1013248977757)) /
          4.0;
      listNearChallenge.add(distance);
    }
    return listNearChallenge;
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
