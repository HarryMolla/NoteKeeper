import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/note.dart';
import 'package:flutter_application_1/utils/database_helper.dart';
import 'package:intl/intl.dart';

class addNote extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  final bool isWhite;
  addNote(this.note, this.appBarTitle, this.isWhite);

  @override
  State<addNote> createState() =>
      _AddNoteState(this.note, this.appBarTitle, this.isWhite);
}

class _AddNoteState extends State<addNote> {
  _AddNoteState(this.note, this.appBarTitle, this.isWhite);

  String appBarTitle;
  Note note;
  DatabaseHelper helper = DatabaseHelper();
  final bool isWhite;

  var someValue = ['High', 'Low'];
  var smallValue = null;
  List<String> _priorities = ['High', 'Low'];

  TextEditingController titleControler = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  //bool isWhite=false;

  @override
  Widget build(BuildContext context) {
    titleControler.text = note.title;
    descriptionController.text = note.description;

    return Scaffold(
      backgroundColor: isWhite ? Color.fromRGBO(0, 22, 17, 0) : Colors.white,
      appBar: AppBar(
        backgroundColor: isWhite
            ? Color.fromRGBO(17, 19, 18, 1)
            : const Color.fromARGB(255, 240, 240, 240),
        title: Text(
          appBarTitle,
          style: TextStyle(color: isWhite ? Colors.white : Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              moveToLastScreen();
            },
            icon: Icon(Icons.arrow_back),
            color: isWhite ? Colors.white : Colors.black),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Column(
                children: [
                  Text('Choose priority', style: TextStyle(color: Colors.grey),),
                  Container(
                      decoration: BoxDecoration(
                         // border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                        padding: EdgeInsets.only(right: 20, left: 20, top: 0),
                        dropdownColor: isWhite ? const Color.fromARGB(255, 41, 41, 41) : Colors.white,
                        value: getPriorityAsString(note.priority),
                        items: someValue.map((String newValue) {
                          return DropdownMenuItem(
                            child: Text(
                              newValue,
                              style: TextStyle(
                                color: isWhite ? Colors.white : Colors.black,
                              ),
                            ),
                            value: newValue,
                          );
                        }).toList(),
                        onChanged: (dtValue) {
                          setState(() {
                            smallValue = dtValue!;
                            updatePriorityAsInt(dtValue);
                          });
                        },
                      ))),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: titleControler,
                onChanged: (value) {
                  updateTitle();
                },
                style: TextStyle(
                  color: isWhite? Colors.white: Colors.black
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(0, 163, 114, 1)),
                  ),
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                onChanged: (value) {
                  updateDescription();
                },
                style: TextStyle(
                  color: isWhite? Colors.white: Colors.black
                ),
                decoration: InputDecoration(
                  hintText: 'Description',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(0, 163, 114, 1))
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color.fromRGBO(0, 163, 114, 1)),
                        // backgroundColor: Color.fromRGBO(71, 168, 139, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      onPressed: () {
                        _delete();
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Color.fromRGBO(0, 163, 114, 1)),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(0, 163, 114, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      onPressed: () {
                        _save();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    switch (value) {
      case 1:
        return _priorities[0]; // 'High'
      case 2:
        return _priorities[1]; // 'Low'
      default:
        return 'Unknown';
    }
  }

  void updateTitle() {
    note.title = titleControler.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    int result = await helper.deleteNote(note.id!);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occurred while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }
}
