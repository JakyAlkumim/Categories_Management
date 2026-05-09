import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/components/crud.dart';
import 'package:note_app/components/customtxt.dart';
import 'package:note_app/constans/linkServerAPI.dart';
import 'package:note_app/main.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  GlobalKey<FormState> formStat = GlobalKey();
  Crud crud = Crud();
  bool isLoading = false;
  File? myFile;

  Future addNote() async {
    isLoading = true;
    setState(() {});
    var response = await crud.postRequestWithFile(linkAddNote, {
      "title": title.text.isEmpty ? "بدون عنوان" : title.text,
      "content": content.text.isEmpty ? "فارغ" : content.text,
      "notes_user": shared.getString("id").toString(),
    }, myFile);
    isLoading = false;
    setState(() {});
    print("الرد القادم من السيرفر : $response");
    if (response['status'] == "success") {
      Navigator.of(context).pushReplacementNamed("home");
    } else {
      print("خطاء : ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Notes"), centerTitle: true),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: [
                  CustomTxt(hint: "Title", controller: title, valid: (val) {}),
                  CustomTxt(
                    hint: "Content",
                    controller: content,
                    valid: (val) {},
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    height: 50,
                    color: myFile == null ? Colors.blue : Colors.green,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    onPressed: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          padding: EdgeInsets.all(10),
                          height: 150,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Text(
                                "Chose From items",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              InkWell(
                                onTap: () async {
                                  XFile? xFile = await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  myFile = File(xFile!.path);
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "From Gallery",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.photo, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              InkWell(
                                onTap: () async {
                                  XFile? xFile = await ImagePicker().pickImage(
                                    source: ImageSource.camera,
                                  );
                                  myFile = File(xFile!.path);
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "From Camera",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Text("Chose File"),
                  ),
                  SizedBox(height: 10),
                  MaterialButton(
                    height: 50,
                    color: Colors.blue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    onPressed: () async {
                      await addNote();
                    },
                    child: Text("Save"),
                  ),
                ],
              ),
            ),
    );
  }
}
