
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

import '../controllers/maps_location_controller.dart';
import 'components/bottom_sheet/item_vendor.dart';
import 'components/bottom_sheet/no_vendor.dart';
import 'components/item_marker.dart';
import 'components/my_location.dart';

class MapsLocationView extends GetView<MapsLocationController> {
  @override
  Widget build(BuildContext context) {
    // set firs location update
    return Scaffold(
        body: Stack(
      children: [
        Obx(() {
          return Animarker(
            mapId: controller.mapController.future.then((value) => value.mapId),
            isActiveTrip: true,
            useRotation: false,
            rippleRadius: Constants.RIPPLE_RADIUS,
            zoom: Constants.CAMERA_ZOOM_IN,
            shouldAnimateCamera: false,
            rippleColor: Colors.amber,
            child: GoogleMap(
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                myLocationEnabled: false,
                mapType: MapType.normal,
                markers: <Marker>{...controller.markers.values.toSet()},
                circles: controller.isDismissibleDialog.value
                    ? controller.setCircleLocation()
                    : controller.blankCircleLocation(),
                initialCameraPosition: CameraPosition(
                    zoom: Constants.CAMERA_ZOOM_INIT,
                    tilt: Constants.CAMERA_TILT,
                    bearing: Constants.CAMERA_BEARING,
                    target: LatLng(
                        controller.user?.latitude ??
                            -8.582572687412386,
                        controller.user?.longitude ??
                            116.1013248977757)),
                onMapCreated: (GoogleMapController ctrl) {
                  controller.mapController.complete(ctrl);
                  controller.setMapController = ctrl;
                  controller.setBuyerMarker();

                }),
          );
        }),
        // Positioned( top: 50, child: Text('${controller.positionStream.value?.longitude}')),
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
          () => Positioned(
            bottom: Get.height * 0.22,
            right: 20,
            child: MyLocation(
                isDismissible: controller.isDismissibleDialog.value,
                func: () {
                  controller.myLocation();
                }),
          ),
        ),
        Obx(
          () => ItemVendor(
              isDismissible: controller.isDismissibleDialog.value,
              func: () {
                controller.isDismissibleDialog.value = true;
                controller.myLocation();
                controller.loadingVendor(
                  context,
                );
              }),
        ),
        Obx(() {
          return controller.isLoadingDismiss.value
              ? controller.itemVendor.length != 0
                  ? ItemMarker(
                      listNear: controller.itemVendor,
                      onPageChanged: (index) {
                        controller.index = index;
                        controller.itemMarkerAnimation(index);
                      },
                      index: controller.indexItem.value,
                      distance: controller.distanceVendor(),
                    )
                  : controller.isDismissibleEmpty.value
                      ? NoVendor(
                          func: () {
                            controller.isLoadingDismiss.value = false;
                            controller.isDismissibleDialog.value = false;
                            controller.isDismissibleEmpty.value = false;
                          },
                        )
                      : Container()
              : Container();
        })
      ],
    ));
  }
}
