import 'package:desafio_mobile/helpers/db.dart';
import 'package:desafio_mobile/model/auth_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class LoginViewModel {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<AuthModel> signInEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
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
          .logLogin(loginMethod: "EmailAndPassword");
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
