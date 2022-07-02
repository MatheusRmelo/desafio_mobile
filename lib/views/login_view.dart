import 'package:desafio_mobile/helpers/routes.dart';
import 'package:desafio_mobile/model/response_model.dart';
import 'package:desafio_mobile/viewmodel/login_viewmodel.dart';
import 'package:desafio_mobile/views/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");

  void _handleClickLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      LoginViewModel.signInEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then((response) {
        if (response.success) {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.home, (route) => false);
        } else {
          final snackBar = errorSnackBar(response.message);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() => _isLoading = false);
        }
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
              Text("Bem vindo", style: theme.textTheme.headline1),
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
                  onPressed: _isLoading ? null : _handleClickLogin,
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
                            const Text("Verificando..."),
                          ],
                        )
                      : const Text("Entre agora"),
                ),
              ),
              TextButton(
                  child: const Text("Ainda não tem conta? Crie agora!"),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.register);
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}
