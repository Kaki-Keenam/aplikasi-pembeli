import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class Constants {
  Constants._();

  // map camera initialized
  static const double CAMERA_ZOOM_INIT = 15;
  static const double CAMERA_ZOOM_OUT = 16;
  static const double CAMERA_ZOOM_IN = 17;
  static const double CAMERA_TILT = 0;
  static const double CAMERA_BEARING = 30;
  static const LatLng SOURCE_LOCATION =
      LatLng(-8.582572687412386, 116.1013248977757);

  // Marker_ID myLocation
  static const String MY_LOCATION_ID = "myLocation";

  // distance nearest area from current location
  static const double NEARBY = 1.043089207917394;

  // Image Marker buyer and vendor
  static const String BUYER_MARKER = "assets/images/marker.png";
  static const String VENDOR_MARKER = "assets/images/merchant.png";

  // animarker
  static const double RIPPLE_RADIUS = 0.35;
  static const double CIRCLE_RADIUS = 400;

  // firestore collection constants
  // child collection of firestore database
  static const String FAVORITE = "favorite";
  static const String FAVORITES = "favorites";

  // Main collection of buyer firestore database
  static const String BUYER = "buyer";

  // Main collection of vendor firesore database
  static const String VENDOR = "vendors";
  static const String PRODUCTS = "products";
  static const String TRANSACTION = "transaction";

  //save shared preference
  static const String SKIP_INTRO = "skipIntro";

  //Query Product
  static const String VENDOR_ID_QUERY = "vendorId";
  static const String BUYER_ID_QUERY = "buyerId";
  static const String ORDER_DATE = "orderDate";
  static const String LAST_LOCATION = "lastLocation";

  // maps Query
  static const String STATUS_QUERY = "status";
  static const String ONLINE = "online";

  // Asset image
  static const String PROFILE = "assets/images/person.png";

  // Radius Filter
  static double DISTANCE_MILE = 0.13;
  static double LAT = 0.0144927536231884;
  static double LONG = 0.0181818181818182;
  static double MARKER_RADIUS = 1040.0;
}
