import 'package:desafio_mobile/model/response_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthModel extends ResponseModel {
  UserCredential? userCredential;

  AuthModel(
      {this.userCredential, required super.success, required super.message});
}
