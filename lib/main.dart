import 'package:desafio_mobile/helpers/routes.dart';
import 'package:desafio_mobile/views/home_view.dart';
import 'package:desafio_mobile/views/login_view.dart';
import 'package:desafio_mobile/views/register_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
            subtitle1: TextStyle(fontSize: 24, color: Colors.black87),
            subtitle2: TextStyle(fontSize: 16, color: Colors.black87),
            headline1: TextStyle(fontSize: 32, color: Colors.black87)),
        primaryColor: const Color(0xFF2F2F2F),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: const Color(0xFF2F2F2F)),
      ),
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? Routes.home
          : Routes.login,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.login:
            return MaterialPageRoute(
                settings: settings, builder: (_) => const LoginView());
          case Routes.register:
            return MaterialPageRoute(
                settings: settings, builder: (_) => const RegisterView());
          case Routes.home:
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => FirebaseAuth.instance.currentUser != null
                    ? const HomeView()
                    : const LoginView());
        }
        return null;
      },
    );
  }
}
