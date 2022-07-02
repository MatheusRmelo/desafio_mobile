import 'package:desafio_mobile/model/response_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterViewmodel {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<ResponseModel> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return ResponseModel(
          success: true,
          message: "Sucesso ao criar conta",
          result: userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ResponseModel(
            success: false,
            message: "Sua senha precisa ter no mínimo 6 caracteres");
      } else if (e.code == 'email-already-in-use') {
        return ResponseModel(
            success: false, message: "Esse e-mail já está registrado");
      }
    }
    return ResponseModel(success: false, message: "Falha ao criar a conta");
  }
}
