import 'package:desafio_mobile/model/response_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<ResponseModel> signInEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return ResponseModel(
          success: true,
          message: "Sucesso ao realizar o LOGIN",
          result: userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ResponseModel(
            success: false, message: 'E-mail ou senha inválidos');
      } else if (e.code == 'wrong-password') {
        return ResponseModel(
            success: false, message: 'E-mail ou senha inválidos');
      }
    }
    return ResponseModel(success: false, message: "Falha ao fazer o LOGIN");
  }
}
