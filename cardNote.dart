import 'package:flutter/material.dart';
import 'package:note_app/constans/linkServerAPI.dart';
import 'package:note_app/modle/notes.dart';

class CardNote extends StatefulWidget {
  final void Function()? onTap;
  final void Function()? onDelete;
  final Notes notes;

  const CardNote({
    super.key,
    required this.onTap,
    this.onDelete,
    required this.notes,
  });

  @override
  State<CardNote> createState() => _CardNoteState();
}

class _CardNoteState extends State<CardNote> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: widget.onTap,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: widget.notes.notesImage == "No File"
                    ? Image.asset("assets/images/note.png")
                    : Image.network(
                        "$linkFileRoot/${widget.notes.notesImage}".trim(),
                        width: 50,
                        height: 100,
                        fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.grey[200],
                      child: Column(
                        children: [
                          Icon(Icons.broken_image, color: Colors.grey[700], size: 30),
                          Text("الصورة غير صالحة",style: TextStyle(fontSize: 10),),
                        ],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                      ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text("${widget.notes.notesTitle}"),
                subtitle: Text("${widget.notes.notesContent}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: widget.onDelete,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
