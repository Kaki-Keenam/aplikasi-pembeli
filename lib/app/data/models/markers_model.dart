import 'package:google_maps_flutter/google_maps_flutter.dart';


class MarkersModel {
  List<Markers>? markersList;

  MarkersModel({
    this.markersList,
  });
}
class Markers{
  Markers({
    this.id,
    this.name,
    this.markerId,
    this.latLng,
    this.street,
    this.image,
});
  String? id;
  String? name;
  MarkerId? markerId;
  LatLng? latLng;
  String? street;
  String? image;
}