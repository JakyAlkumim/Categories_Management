import 'package:flutter/material.dart';

class Success extends StatefulWidget {
  const Success({super.key});
  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "تم انشاء الحساب بنجاح الان يمكنك تسجيل الدخول ",
              style: TextStyle(fontSize: 16),
            ),
          ),
          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false,);
            },
            child: Text("Login"),
          ),
        ],
      ),
    );
  }
}
