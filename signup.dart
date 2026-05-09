import 'package:flutter/material.dart';
import 'package:note_app/components/crud.dart';
import 'package:note_app/components/customtxt.dart';
import 'package:note_app/components/valid.dard.dart';
import 'package:note_app/constans/linkServerAPI.dart';
import 'package:note_app/main.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  final Crud _crud = Crud();
  bool isLoading = false;

  Future signUp() async {
    try {
      if(formState.currentState!.validate()){
        isLoading = true;
        setState(() {});
        var response = await _crud.postRequest(linkSignUp, {
          "userName": username.text,
          "email": email.text,
          "password": password.text,
        });
        isLoading = false;
        setState(() {});
        if (response != null) {
          if (response['status'] == "success") {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil("success", (route) => false);
          } else {
            print("خطاء في انشاء الحساب");
          }
        } else {
          print("لم يتم استلام رد من السيرفر، تأكد من الـ IP والاتصال");
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
                          hint: "User Name",
                          controller: username,
                          valid: (val) {
                            return validInput(val!, 20, 5);
                          },
                        ),
                        CustomTxt(
                          hint: "Email",
                          controller: email,
                          valid: (val) {
                            return validInput(val!, 40, 5);
                          },
                        ),
                        CustomTxt(
                          hint: "Password",
                          controller: password,
                          valid: (val) {
                            return validInput(val!, 10, 4);
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () async {
                            await signUp();
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              "login",
                              (route) => false,
                            );
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.blue),
                          ),
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
