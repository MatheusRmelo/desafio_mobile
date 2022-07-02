import 'package:desafio_mobile/model/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<AuthModel> signInEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthModel(
          userCredential: userCredential,
          success: true,
          message: "Sucesso ao realizar o LOGIN");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AuthModel(success: false, message: 'E-mail ou senha inválidos');
      } else if (e.code == 'wrong-password') {
        return AuthModel(success: false, message: 'E-mail ou senha inválidos');
      }
    }
    return AuthModel(success: false, message: "Falha ao fazer o LOGIN");
  }
}
