import 'package:get/get.dart';

class DashboardController extends GetxController {
  var loading = false.obs;
  var _selectedIndex = 0.obs;

  getIndex() => _selectedIndex.value;

  setIndex(index) => _selectedIndex.value = index;

}
