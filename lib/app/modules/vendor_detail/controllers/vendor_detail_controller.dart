import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/modules/home/controllers/home_controller.dart';

class VendorDetailController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  final HomeController _controller = Get.find<HomeController>();

  Rxn<GeoPoint> _buyerLoc = Rxn<GeoPoint>();
  GeoPoint? get buyerLoc => this._buyerLoc.value;

  @override
  void onInit(){
    _buyerLoc.bindStream(getBuyerLoc());
    super.onInit();
  }

  Stream<List<ProductModel>> getProduct(String vendorId){
    try{
      return _repositoryRemote.getProduct(vendorId).map((QuerySnapshot query) {
        List<ProductModel> listData = List.empty(growable: true);
        query.docs.forEach((element) {
          listData.add(ProductModel.fromDocument(element));
        });
        return listData;
      });
    }catch(e){
      print('vendorId: ${e.toString()}');
      rethrow;
    }
  }

  Future<VendorModel> getVendor(String vendorId){
    return _repositoryRemote.getVendor(vendorId);
  }

  Stream<GeoPoint> getBuyerLoc(){
    return _controller.getBuyerLoc();
  }
}
