import 'package:email_validator/email_validator.dart';
import 'package:kakikeenam/app/modules/components/widgets/notify_dialogs.dart';

class Validator {
  static get dialogs => NotifyDialogs();
  static String? errorText;

  static Future<bool> registerValid(String password, String confirmPw, String email) async {
    if (email.isEmpty || password.isEmpty || confirmPw.isEmpty) {
      errorText = "Semua kolom harus diisi!";
      dialogs.errorDialog(errorText ?? "");
      return false;
    }
    if (!EmailValidator.validate(email)){
      errorText = "Email tidak valid!";
      dialogs.errorDialog(errorText ?? "");
      return false;
    }
    if (password != confirmPw){
      errorText = "Konfirmasi Password tidak sama!";
      dialogs.errorDialog(errorText ??"");
      return false;
    }
    if(true){
      return true;
    }
  }
}