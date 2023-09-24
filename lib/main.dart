import 'package:firebase_core/firebase_core.dart';
import 'package:scholar_app/constants.dart';
import 'package:scholar_app/firebase_options.dart';
import 'package:scholar_app/screens/home_screen.dart';
import 'package:scholar_app/screens/login_screen.dart';
import 'package:scholar_app/screens/register_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CurrentMaterialApp());
}

class CurrentMaterialApp extends StatelessWidget {
  const CurrentMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: kPrimaryColor),
      ),
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        ChatScreen.id: (context) =>  ChatScreen(),
      },
      initialRoute: LoginScreen.id,
    );
  }
}
