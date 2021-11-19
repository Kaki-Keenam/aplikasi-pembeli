import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';
import 'package:kakikeenam/app/utils/utils.dart';

class AuthRemote {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentGoogle;
  UserCredential? userCredential;


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

      final _isSign = await googleSignIn.isSignedIn();
      if (_isSign) {
        await googleSignIn
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
        return true;
      } else if (_auth.currentUser!.emailVerified == true) {
        addToFirebase();
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final box = GetStorage();
      box.writeIfNull(Constants.SKIP_INTRO, true);

      await googleSignIn.signOut();
      await googleSignIn.signIn().then((value) => _currentGoogle = value);
      final isSign = await googleSignIn.isSignedIn();
      if (isSign) {
        final _googleAuth = await _currentGoogle!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken,
          accessToken: _googleAuth.accessToken,
        );

        await _auth
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        addToFirebase();
        CollectionReference users = _db.collection(Constants.BUYER);
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
      } else {
        Dialogs.errorDialog("Login with Google");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> registerAuth(
      String email, String password, String name,) async {

    try {
      UserCredential _userSignup = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('register: error');
      addToFirebase(name);
      await _userSignup.user?.sendEmailVerification();

      Dialogs.verifyDialog();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Password terlalu lemah');
      } else if (e.code == 'email-already-in-use') {
        Dialogs.errorEmailDialog(
            func: () {
              Get.back();
            }
        );
      }
    } catch (e) {
      print('register : ${e.toString()}');
      Dialogs.errorDialog("Registrasi error");
    }
  }

  Future<void> loginAuth(String email, String password) async {
    CollectionReference users = _db.collection(Constants.BUYER);
    final box = GetStorage();
    box.writeIfNull(Constants.SKIP_INTRO, true);
    try {
      UserCredential _userLogin = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_userLogin.user!.emailVerified) {
        addToFirebase();
        Get.offAllNamed(Routes.PAGE_SWITCHER);
      } else {
        Dialogs.repeatVerifyDialog(
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

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.back();
        Dialogs.emailNotFoundDialog();
      } else if (e.code == 'wrong-password') {
        Get.back();
        Dialogs.wrongPasswordDialog();
      }
    } catch (e) {
      Get.back();
      Dialogs.errorDialog("Login error");
    }
  }

  void resetPassword(String email) async {
    if (email != "" && GetUtils.isEmail(email)) {
      try {
        await _auth.sendPasswordResetEmail(email: email);
        Dialogs.resetPasswordDialog();
      } on FirebaseAuthException catch (e) {
        if (e.code != "") {
          Dialogs.errorDialog("Reset Password");
        }
      }
    }
  }

  Future<void> logout() async {
    final _isSign = await googleSignIn.isSignedIn();

    if (_isSign) {
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      print('google: $_isSign');
      Get.offAllNamed(Routes.WELCOME_PAGE);
    } else {
      await _auth.signOut();
      print('auth: $_isSign');
      Get.offAllNamed(Routes.WELCOME_PAGE);
    }
  }

  Future<void> addToFirebase([String name = "User"]) async {
    try {
      CollectionReference users = _db.collection(Constants.BUYER);
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
    } catch (e) {
      print(e.toString());
    }
  }
}