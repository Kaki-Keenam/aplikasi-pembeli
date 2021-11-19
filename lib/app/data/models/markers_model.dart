import 'package:cloud_firestore/cloud_firestore.dart';


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
    this.distance,
    this.street,
    this.rating,
    this.image,
  });
  String? id;
  String? name;
  String? markerId;
  double? rating;
  double? distance;
  GeoPoint? latLng;
  String? street;
  String? image;
}