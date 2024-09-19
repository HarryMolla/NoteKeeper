import 'dart:async';
import 'dart:io' if (dart.library.js) 'dart:js_util' as js_util;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/note.dart';
import 'package:flutter_application_1/utils/database_helper.dart';
import 'package:flutter_application_1/Note_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_1/StateFull.dart';

class NoteBook extends StatefulWidget {
  const NoteBook({super.key});

  @override
  State<NoteBook> createState() => _NoteBookState();
}

class _NoteBookState extends State<NoteBook> {
  
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList = [];
  int count = 0;
  bool isWhite=true;
  bool iconSwap=true;

  void _backgroundColorsToggle() {
    setState(() {
      isWhite = !isWhite;
    });
  }
  
 void _iconsSwapForToggle(){
    setState(() {
      iconSwap=!iconSwap;
    });
 }

  @override
  Widget build(BuildContext context) {
     final isWhite = Theme.of(context).scaffoldBackgroundColor == Colors.white;
    if (noteList.isEmpty) {
      updateListView();
    }

    return Scaffold(
      backgroundColor: isWhite? Color.fromRGBO(0, 22, 17, 0): Colors.white,
      appBar: AppBar(
       backgroundColor: isWhite? Color.fromRGBO(17, 19, 18, 1): const Color.fromARGB(255, 240, 240, 240),
        title: Text(
          'Notebook',
          style: TextStyle(
            color: isWhite? Colors.white: Colors.black
            )
        ),
        actions: [
          CircleAvatar(
            backgroundColor: isWhite? Colors.white60: Colors.black26,
           child:  IconButton(
            onPressed: (){
           final myState = MyState.of(context);
              myState?.toggleBackgroundColors(); 
              _iconsSwapForToggle();
            }, 
            icon: Icon(iconSwap? Icons.sunny: Icons.nightlight,color: isWhite? Colors.black: Colors.white,)
            )
          ),
          Container(width: 15, ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 163, 114, 1),
        onPressed: () {
          NavigateToDetail(Note('', '', 2), 'Add note', isWhite);
        },
        child: const Icon(Icons.add, color: Color.fromARGB(255, 228, 210, 210),),
        shape: const OvalBorder(),
      ),
      body: ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          return Column(

          children: [ 
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0,),
            onTap: () {
              NavigateToDetail(noteList[index], "Edit note", isWhite);
            },
            title: Text(noteList[index].title, style: TextStyle(color: isWhite? Colors.white: Colors.black),),
            subtitle: Text(
              noteList[index].description,
              style: const TextStyle(color: Colors.grey),
            ),
            leading: Container(
              child: Icon(Icons.donut_small, size: 5, color: Colors.white,),
              height: 500,
              width: 8,
              color:const Color.fromARGB(255, 24, 151, 77),
              //backgroundColor: getPriorityColor(noteList[index].priority),//dont delete this
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
          ),
         Divider(
          thickness: 0.5,
          height: 0,
          color: isWhite? const Color.fromARGB(255, 44, 44, 44): const Color.fromARGB(255, 218, 217, 217),
         )
          ]
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

  void NavigateToDetail(Note note, String title,bool isWhite) async {
    bool result= await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return addNote(note, title, isWhite);
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
