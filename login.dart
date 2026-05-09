import 'package:awesome_dialog_plus/awesome_dialog_plus.dart';
import 'package:flutter/material.dart';
import 'package:note_app/components/crud.dart';
import 'package:note_app/components/customtxt.dart';
import 'package:note_app/constans/linkServerAPI.dart';

import '../../components/valid.dard.dart';
import '../../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  Crud crud = Crud();
  bool isLoading = false;

  Future logIn() async {
    try {
      if (formState.currentState!.validate()) {
        isLoading = true;
        setState(() {});
        var response = await crud.postRequest(linkLogIn, {
          "email": email.text,
          "password": password.text,
        });
        isLoading = false;
        setState(() {});
        //print("الرد القادم من السيرفر $response");
        if (response != null  && response['status'] == "success") {
          shared.setString("id", response['data']['id'].toString());
          shared.setString("username", response['data']['userName']);
          shared.setString("email", response['data']['email']);
          shared.setString("password", response['data']['password']);
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil("home", (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("تم تسجيل الدخول بنجاح"),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: 'تنبية',
            body: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text("كلمة المرور او البريد الاكتروني غير صحيح"),
            ),
          )..show();
        }
      }
    } catch (e) {
      print("خطاء : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  Form(
                    key: formState,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Image.asset(
                          "assets/images/note.png",
                          height: 200,
                          width: 200,
                        ),
                        SizedBox(height: 20),
                        CustomTxt(
                          hint: "Email",
                          controller: email,
                          valid: (val) {
                            return validInputEmail(val!);
                          },
                        ),
                        CustomTxt(
                          hint: "Password",
                          controller: password,
                          valid: (val) {
                            return validInputPass(val!);
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () async {
                            await logIn();
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.blue),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed("signup");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
