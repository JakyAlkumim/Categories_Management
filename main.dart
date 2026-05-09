import 'package:flutter/material.dart';
import 'package:note_app/app/auth/signup.dart';
import 'package:note_app/app/auth/success.dart';
import 'package:note_app/app/home.dart';
import 'package:note_app/app/notes/add.dart';
import 'package:note_app/app/notes/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/auth/login.dart';

late SharedPreferences shared;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  shared = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: shared.getString("id") == null ? "login" : "home",
      routes: {
        "login" : (context) => Login(),
        "signup" : (context) => SignUp(),
        "home" : (context) => Home(),
        "success" : (context) => Success(),
        "add" : (context) => AddNote(),
        "edit" : (context) => EditNote(),
      },
    );
  }
}
