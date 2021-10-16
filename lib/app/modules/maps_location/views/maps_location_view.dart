import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kakikeenam/app/data/services/transaction/transaction_state.dart';
import 'package:kakikeenam/app/modules/components/widgets/loading_view.dart';
import 'package:kakikeenam/app/modules/maps_location/views/components/item_marker.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

import '../controllers/maps_location_controller.dart';
import 'components/bottom_sheet/item_vendor.dart';
import 'components/my_location.dart';

class MapsLocationView extends GetView<MapsLocationController> {
  final idleC = Get.find<Transaction_state_controller>();
  final mapsC = Get.put(MapsLocationController());

  @override
  Widget build(BuildContext context) {
    // set firs location update
    return Scaffold(
      body: Stack(
        children: [
          GetBuilder<MapsLocationController>(
            initState: (e) {
              Future.delayed(
                  Duration(seconds: 3), () => e.controller?.getLastLocation());
            },
            builder: (getController) {
              return Animarker(
                mapId: getController.mController.future
                    .then((value) => value.mapId),
                isActiveTrip: true,
                useRotation: false,
                rippleRadius: Constants.RIPPLE_RADIUS,
                zoom: Constants.CAMERA_ZOOM_IN,
                shouldAnimateCamera: false,
                rippleColor: Colors.amber,
                markers: <Marker>{
                  ...getController.markers.values.toSet(),
                },
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  myLocationEnabled: !getController.isDismissibleDialog.value,
                  mapType: MapType.normal,
                  circles: getController.isDismissibleDialog.value
                      ? getController.setCircleLocation()
                      : getController.blankCircleLocation(),
                  initialCameraPosition: getController.initPosition,
                  onMapCreated: getController.mapCreated,
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Get.offAllNamed(Routes.PAGE_SWITCHER),
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(
                () => MyLocation(
                isDismissible: controller.isDismissibleDialog.value,
                func: () {
                  controller.myLocation();
                }),
          ),
          Obx(
                () => ItemVendor(
                isDismissible: controller.isDismissibleDialog.value,
                func: () {
                  controller.getLastLocation();
                  controller.isDismissibleDialog.value = true;
                  controller.loadingVendor(
                    context,
                  );
                }),
          ),
          StreamBuilder<QuerySnapshot<Object?>>(
            stream: controller.addLatLangMarkers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var _index = 0;
                var data = snapshot.data!.docs;
                var markerId = data.map((vendor) => vendor["uid"]);
                var latLng = data.map((vendor) => vendor["lastLocation"]);
                var name = data.map((vendor) => vendor["storeName"]);
                var image = data.map((vendor) => vendor["storeImage"]);
                controller.setDataVendor(
                  marker: markerId,
                  latLng: latLng,
                  name: name,
                  image: image,
                );
                return Obx(() => controller.isLoadingDismiss.value
                    ? ItemMarker(
                  listNear: controller.nearMarker.value.markersList,
                  onPageChanged: (index) {
                    _index = index;
                    controller.itemMarkerAnimation(index);
                  },
                  index: _index,
                )
                    : Container());
              }
              return LoadingView();
            },
          ),
        ],
      ),
    );
  }
}
