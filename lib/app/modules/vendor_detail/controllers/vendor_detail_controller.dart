import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';

class VendorDetailController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();

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
}
