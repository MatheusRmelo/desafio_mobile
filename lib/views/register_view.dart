import 'package:desafio_mobile/helpers/routes.dart';
import 'package:desafio_mobile/model/response_model.dart';
import 'package:desafio_mobile/viewmodel/login_viewmodel.dart';
import 'package:desafio_mobile/viewmodel/register_viewmodel.dart';
import 'package:desafio_mobile/views/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");

  void _handleClickRegister() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      RegisterViewmodel.createUserWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.home, (route) => false);
      }).catchError((error) {
        final snackBar =
            errorSnackBar(error is String ? error : "Falha ao tentar o Login");
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() => _isLoading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(children: [
              Text("Crie sua conta", style: theme.textTheme.headline1),
              const SizedBox(height: 24),
              TextFormField(
                style: const TextStyle(fontSize: 18),
                controller: _emailController,
                validator: (String? text) {
                  if (text == null) {
                    return "Informe um e-mail";
                  }
                  if (text.isEmpty) {
                    return "Informe um e-mail";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("E-mail")),
              ),
              const SizedBox(height: 16),
              TextFormField(
                style: const TextStyle(fontSize: 18),
                obscureText: true,
                controller: _passwordController,
                validator: (String? text) {
                  if (text == null) {
                    return "Informe uma senha";
                  }
                  if (text.isEmpty) {
                    return "Informe uma senha";
                  }
                  if (text.length < 6) {
                    return "Sua senha precisa ter no mínimo 6 caracteres";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Senha")),
              ),
              Container(
                width: double.infinity,
                height: 48,
                margin: const EdgeInsets.only(top: 24, bottom: 8),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleClickRegister,
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 16),
                                child: const CircularProgressIndicator(
                                  color: Colors.grey,
                                )),
                            const Text("Salvando seus dados..."),
                          ],
                        )
                      : const Text("Criar conta"),
                ),
              ),
              TextButton(
                  child: const Text("Já tem conta? Entre agora!"),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushNamed(context, Routes.login);
                    }
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}
