import 'package:desafio_mobile/helpers/db.dart';
import 'package:desafio_mobile/model/auth_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class RegisterViewmodel {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<AuthModel> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var database = await DB.connectToDabase();
      await database.transaction((txn) async {
        await txn.rawInsert(
            'INSERT INTO logins(uid, created_at) VALUES(?, ?)', [
          userCredential.user!.email,
          DateFormat("yyyy-MM-dd").format(DateTime.now())
        ]);
      });
      database.close();
      await FirebaseAnalytics.instance
          .logSignUp(signUpMethod: "EmailAndPassword");
      return AuthModel(
          userCredential: userCredential,
          success: true,
          message: "Sucesso ao criar conta");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return AuthModel(
            success: false,
            message: "Sua senha precisa ter no mínimo 6 caracteres");
      } else if (e.code == 'email-already-in-use') {
        return AuthModel(
            success: false, message: "Esse e-mail já está registrado");
      }
    }
    return AuthModel(success: false, message: "Falha ao criar a conta");
  }
}
