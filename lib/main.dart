import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:office_administrator_app/screens/opening/login.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Office Administrator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'poppins',
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),displayMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black
          ),
          displayLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.black
          )
        )
      ),
      home: LoginPage(),
      );
  }
}
