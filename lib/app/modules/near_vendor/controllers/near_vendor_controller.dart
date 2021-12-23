import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/modules/home/controllers/home_controller.dart';

class NearVendorController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  final HomeController _controller = Get.find<HomeController>();
  Stream<GeoPoint> getBuyerLoc(){
    return _controller.getBuyerLoc();
  }

  Stream<List<VendorModel>> getVendorId(GeoPoint? location){
    return _controller.getVendorId(location);
  }

  Stream<List<ProductModel>> getNearProduct(List<VendorModel>? query){
    return _controller.getNearProduct(query);
  }

  Stream<VendorModel> getVendor(String? vendorId) {
    return _repositoryRemote.getVendorStream(vendorId!).map((event) {
      return VendorModel.fromDocument(event);
    });
  }

}
