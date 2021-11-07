import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RepositoryRemote _repositoryRemote = Get.put(RepositoryRemote(), permanent: true);

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  _init() async {
    var skipIntro = await _repositoryRemote.skipIntro();
    _auth.authStateChanges().listen((User? user) {

      if (skipIntro) {
        if(user != null && _auth.currentUser?.emailVerified == true){
          Get.offAllNamed(Routes.PAGE_SWITCHER);
          print('User has sign in!');
        }else{
          Get.offAllNamed(Routes.WELCOME_PAGE);
          print('User has sign out!');
        }
      } else {
        Get.offAllNamed(Routes.ONBOARDING);
      }
    });
  }
}
