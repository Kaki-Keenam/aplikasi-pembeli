import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';

class SplashController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();

  var user = Rxn<User>();

  bool get isAuth => this._repositoryRemote.isAuth.value;
  bool get isSkip => this._repositoryRemote.isSkipIntro.value;

  @override
  void onInit() {
    user.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future<void> initialize() async {
    _repositoryRemote.firsInitialized();
  }
}
