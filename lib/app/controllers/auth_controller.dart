import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakikeenam/app/controllers/helper_controller.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/data/services/fcm.dart';
import 'package:kakikeenam/app/modules/components/widgets/notify_dialogs.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class AuthController extends GetxController {
  final connectC = Get.put(HelperController());
  var isSkipIntro = false.obs;
  var isAuth = false.obs;
  var loading = false.obs;
  var isValid = false.obs;
  var dialogs = NotifyDialogs();

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentGoogle;
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? userCredential;
  FirebaseFirestore _dbStore = FirebaseFirestore.instance;
  String? errorText;
  var user = UserModel().obs;
  UserModel get userValue => user.value;

  Rxn<User> _firebaseUser = Rxn<User>();
  User? get userAuth => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  /// This function for initialized auto login and skip intro
  /// after buyer login at first time.
  Future<void> firsInitialized() async {
    if (connectC.connectionStatus == ConnectivityResult.none) {
      skipIntro().then((value) => isSkipIntro.value = value);
      isAuth.value = false;
    } else{
      skipIntro().then((value) => isSkipIntro.value = value);
      autoLogin().then((value) => isAuth.value = value);
    }
  }

  Future<bool> skipIntro() async {
    final box = GetStorage();
    if (box.read(Constants.SKIP_INTRO) != null ||
        box.read(Constants.SKIP_INTRO) == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    try {

      final _isSign = await _googleSignIn.isSignedIn();
      if (_isSign) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentGoogle = value);
        final googleAuth = await _currentGoogle!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        addToFirebase();
        Fcm().initFirebaseMessaging(userId: userValue.uid!);
        return true;
      } else if (_auth.currentUser!.emailVerified == true) {
        addToFirebase();
        Fcm().initFirebaseMessaging(userId: userValue.uid!);
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      if (connectC.connectionStatus == ConnectivityResult.none) {
        dialogs.noInternetConnection(
            confirm: (){
              Get.back();
              loading.value = false;
            }
        );
      }
      final box = GetStorage();
      box.writeIfNull(Constants.SKIP_INTRO, true);
      CollectionReference users = _dbStore.collection(Constants.BUYER);

      // digunakan untuk mengatasi kebocoran data
      await _googleSignIn.signOut();

      // digunakan untuk mendapatkan login google
      await _googleSignIn.signIn().then((value) => _currentGoogle = value);

      // digunakan untuk mengecek status login
      final isSign = await _googleSignIn.isSignedIn();
      if (isSign) {
        final _googleAuth = await _currentGoogle!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken,
          accessToken: _googleAuth.accessToken,
        );

        await _auth
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        // simpan status user yang pernah melakukan login satu kali
        // maka tidak menampilkan onboarding

        addToFirebase();

        final dataFav = await users
            .doc(_auth.currentUser!.uid)
            .collection(Constants.FAVORITE)
            .doc(_auth.currentUser!.email);
        final cekFav = await dataFav.get();
        if (cekFav.data() == null) {
          await dataFav.set({
            "favorites": [],
          });
        }
        Get.offAllNamed(Routes.PAGE_SWITCHER);
        Fcm().initFirebaseMessaging(userId: userValue.uid!);
      } else {
        dialogs.errorDialog("Login with Google");
      }
    } catch (e) {
      print(e);
    }
  }

  // login dengan auth

  Future<void> registerAuth(
      String email, String password, String name,) async {

    loading.value = true;
    try {
      if (connectC.connectionStatus == ConnectivityResult.none) {
        dialogs.noInternetConnection(
            confirm: (){
              Get.back();
              loading.value = false;
            }
        );
      }
      UserCredential _userSignup = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      addToFirebase(name);
      loading.value = false;
      await _userSignup.user!.sendEmailVerification();

      dialogs.verifyDialog();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Password terlalu lemah');
      } else if (e.code == 'email-already-in-use') {
        dialogs.errorEmailDialog(
          func: () {
            loading.value = false;
            Get.back();
          }
        );
      }
    } catch (e) {
      dialogs.errorDialog("Registrasi error");
    }
  }

  Future<void> loginAuth(String email, String password) async {
    CollectionReference users = _dbStore.collection(Constants.BUYER);
    loading.value = true;
    final box = GetStorage();
    box.writeIfNull(Constants.SKIP_INTRO, true);
    try {
      if (connectC.connectionStatus == ConnectivityResult.none) {
        dialogs.noInternetConnection(
            confirm: (){
              Get.back();
              loading.value = false;
            }
        );
      }
      UserCredential _userLogin = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_userLogin.user!.emailVerified) {
        addToFirebase();
        Fcm().initFirebaseMessaging(userId: userValue.uid!);
        Get.offAllNamed(Routes.PAGE_SWITCHER);
      } else {
        dialogs.repeatVerifyDialog(
          func: () async {
            await _userLogin.user!.sendEmailVerification();
            Get.back();
          }
        );
      }
      final dataFav = await users
          .doc(_auth.currentUser!.uid)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email);
      final cekFav = await dataFav.get();
      if (cekFav.data() == null) {
        await dataFav.set({
          "favorites": [],
        });
      }
      loading.value = false;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        loading.value = false;
        Get.back();
        errorText = e.message;
        dialogs.emailNotFoundDialog();
      } else if (e.code == 'wrong-password') {
        loading.value = false;
        Get.back();
        errorText = e.message;
        dialogs.wrongPasswordDialog();
      }
    } catch (e) {
      loading.value = false;
      Get.back();
      errorText = e.toString();
      dialogs.errorDialog("Login error");
    }
  }

  void resetPassword(String email) async {
    if (email.isEmpty) {
      errorText = "Kolom email harus diisi!";
      dialogs.errorDialog(errorText ?? "");
      return;
    }
    if (!EmailValidator.validate(email)) {
      errorText = "Email tidak valid!";
      dialogs.errorDialog(errorText ?? "");
      return;
    }
    if (email != "" && GetUtils.isEmail(email)) {
      try {
        if (connectC.connectionStatus == ConnectivityResult.none) {
          dialogs.noInternetConnection(
              confirm: (){
                Get.back();
                loading.value = false;
              }
          );
        }
        await _auth.sendPasswordResetEmail(email: email);
        dialogs.resetPasswordDialog();
      } on FirebaseAuthException catch (e) {
        if (e.code != "") {
          dialogs.errorDialog("Reset Password");
        }
      }
    }
  }

  Future<void> logout() async {
    final _isSign = await _googleSignIn.isSignedIn();
    if (_isSign) {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      loading.value = false;
      Get.offAllNamed(Routes.WELCOME_PAGE);
    } else {
      await _auth.signOut();
      loading.value = false;
      Get.offAllNamed(Routes.WELCOME_PAGE);
    }
  }

  Future<void> addToFirebase([String name = "User"]) async {
    try {
      CollectionReference users = _dbStore.collection(Constants.BUYER);
      User _currentUser = _auth.currentUser!;

      final cekUser = await users.doc(_currentUser.uid).get();
      if (cekUser.data() == null) {
        await users.doc(_currentUser.uid).set({
          "uid": _currentUser.uid,
          "name": _currentUser.displayName ?? name,
          "email": _currentUser.email,
          "photoUrl": _currentUser.photoURL,
          "token": null,
          "creationTime": _currentUser.metadata.creationTime!.toIso8601String(),
          "lastSignTime":
              _currentUser.metadata.lastSignInTime!.toIso8601String(),
          "updateTime": DateTime.now().toIso8601String(),
        });
      } else {
        await users.doc(_currentUser.uid).update({
          "lastSignTime":
              _currentUser.metadata.lastSignInTime!.toIso8601String(),
        });
      }

      final currUser = await users.doc(_currentUser.uid).get();
      final currUserData = currUser.data() as Map<String, dynamic>;

      user(UserModel.fromDocument(currUserData));
      user.refresh();
    } catch (e) {
      print(e.toString());
    }
  }

  /// change profile use for update profile send to firestore
  void editName(String name) async {
    loading.value = true;
    String date = DateTime.now().toIso8601String();
    CollectionReference users = _dbStore.collection(Constants.BUYER);
    try {
      await users.doc(_auth.currentUser!.uid).update({
        "name": name,
        "updateTime": date,
      });
      // Update model
      user.update((user) {
        user!.name = name;
        user.updateTime = date;
      });
      user.refresh();
      loading.value = false;
      dialogs.editSuccess();
    } catch (e) {
      loading.value = false;
      dialogs.errorDialog(e.toString());
    }
  }

  /// Update photo profile
  void updatePhoto(String url) async {
    loading.value = true;
    String date = DateTime.now().toIso8601String();
    CollectionReference users = _dbStore.collection(Constants.BUYER);
    try {
      await users.doc(_auth.currentUser!.uid).update({
        "photoUrl": url,
        "updateTime": date,
      });
      // Update model
      user.update((user) {
        user!.photoUrl = url;
        user.updateTime = date;
      });
      loading.value = false;
    } catch (e) {
      loading.value = false;
      dialogs.errorDialog(e.toString());
    }
  }
}
