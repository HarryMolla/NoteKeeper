import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/note.dart';
import 'package:flutter_application_1/utils/database_helper.dart';
import 'package:intl/intl.dart';

class addNote extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  addNote(this.note, this.appBarTitle);

  @override
  State<addNote> createState() => _AddNoteState(this.note, this.appBarTitle);
}

class _AddNoteState extends State<addNote> {
  _AddNoteState(this.note, this.appBarTitle);

  String appBarTitle;
  Note note;
  DatabaseHelper helper = DatabaseHelper();

  var someValue = ['High', 'Low'];
  var smallValue = 'High';
  List<String> _priorities = ['High', 'Low'];

  TextEditingController titleControler = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleControler.text = note.title;
    descriptionController.text = note.description;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          appBarTitle,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            moveToLastScreen();
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              DropdownButton(
                value: getPriorityAsString(note.priority),
                items: someValue.map((String newValue) {
                  return DropdownMenuItem(
                    child: Text(newValue),
                    value: newValue,
                  );
                }).toList(),
                onChanged: (dtValue) {
                  setState(() {
                    smallValue = dtValue!;
                    updatePriorityAsInt(dtValue);
                  });
                },
              ),
              TextFormField(
                controller: titleControler,
                onChanged: (value) {
                  updateTitle();
                },
                decoration: InputDecoration(
                  hintText: 'Type your title...',
                  labelText: 'Title',
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
                decoration: InputDecoration(
                  hintText: 'Type the note description...',
                  labelText: 'Description',
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      onPressed: () {
                        _delete();
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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
