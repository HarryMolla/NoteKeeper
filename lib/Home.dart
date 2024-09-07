import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/note.dart';
import 'package:flutter_application_1/utils/database_helper.dart';
import 'package:flutter_application_1/Note_detail.dart';
import 'package:sqflite/sqflite.dart';

class NoteBook extends StatefulWidget {
  const NoteBook({super.key});

  @override
  State<NoteBook> createState() => _NoteBookState();
}

class _NoteBookState extends State<NoteBook> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList = [];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList.isEmpty) {
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'Notebook',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigateToDetail(Note('', '', 2), 'Add note');
        },
        child: const Icon(Icons.add),
        shape: const OvalBorder(),
      ),
      body: ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              NavigateToDetail(noteList[index], "Edit note");
            },
            title: Text(noteList[index].title),
            subtitle: Text(
              noteList[index].description,
              style: const TextStyle(color: Colors.grey),
            ),
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList[index].priority),
              child: const Icon(Icons.arrow_right),
            ),
            trailing: IconButton(
              onPressed: () {
                _delete(context, noteList[index]);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void NavigateToDetail(Note note, String title) async {
    bool result= await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return addNote(note, title);
      },
    ));
    if (result==true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
