import 'package:flutter/material.dart';
import 'package:note_app/app/notes/edit.dart';
import 'package:note_app/components/cardNote.dart';
import 'package:note_app/components/crud.dart';
import 'package:note_app/constans/linkServerAPI.dart';
import 'package:note_app/main.dart';
import 'package:note_app/modle/notes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Crud crud = Crud();

  Future getView() async {
    var response = crud.postRequest(linkViewNote, {"id": shared.get("id")});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context).pushNamed("add");
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: EdgeInsets.all(20),
                    title: Text("تنبية"),
                    content: Text("هل تريد تسجيل الخروج من التطبيق؟"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          shared.clear();
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil("login", (route) => false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("تم تسجيل الخروج بنجاح")),
                          );
                        },
                        child: Text("Ok"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.exit_to_app_outlined, color: Colors.red),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          // physics: BouncingScrollPhysics(),
          children: [
            FutureBuilder(
              future: getView(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['status'] == "fial") {
                    return Center(
                      child: Column(
                        children: [
                          Text(
                            "لايوجد ملاحظات",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Icon(
                            Icons.no_backpack_outlined,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data['data'].length,
                    itemBuilder: (context, i) {
                      return CardNote(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditNote(notes: snapshot.data['data'][i]),
                            ),
                          );
                        },
                        notes: Notes.fromJson(snapshot.data['data'][i]),
                        onDelete: () async {
                          var response = await crud
                              .postRequest(linkDeleteNote, {
                                "id": snapshot.data['data'][i]['notes_id'].toString(),
                                "filename": snapshot.data['data'][i]['notes_image'].toString(),
                              });
                          if (response['status'] == "success") {
                            Navigator.of(context).pushReplacementNamed("home");
                          }
                        },
                      );
                    },
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("Loading..."));
                }
                return Center(child: Text("لايوجد اتصال بالانترنت او السيرفر"));
              },
            ),
          ],
        ),
      ),
    );
  }
}
