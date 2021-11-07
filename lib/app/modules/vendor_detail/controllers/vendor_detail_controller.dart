import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';

class VendorDetailController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();

  Stream<List<ProductModel>> getProduct(String vendorId){
   return _repositoryRemote.getProduct(vendorId);
  }
}
