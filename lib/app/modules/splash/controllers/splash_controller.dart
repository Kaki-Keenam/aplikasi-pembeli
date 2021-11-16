import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/data/services/messaging/fcm.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  final Fcm _fcm = Get.find<Fcm>();


  @override
  void onInit() {
    _init();
    super.onInit();
  }

  _init() async {
    var skipIntro = await _repositoryRemote.skipIntro;
    _auth.authStateChanges().listen((User? user) {
      if (skipIntro) {
        print('skip ${skipIntro}');
        if(user != null && user.emailVerified == true){
          Get.offAllNamed(Routes.PAGE_SWITCHER);
          _fcm.initFirebaseMessaging(userId: user.uid);
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
