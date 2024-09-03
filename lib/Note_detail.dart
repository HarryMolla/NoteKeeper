import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class addNote extends StatefulWidget {
   
   String appBarTitle;
   addNote(this.appBarTitle);
  

  @override
  State<addNote> createState() =>_addNoteState(appBarTitle);
  
}

class _addNoteState extends State<addNote> {
  _addNoteState(this.appBarTitle);
  String appBarTitle;
  var someValue = ['High', 'Low'];
  var smallValue = 'High';
  
  TextEditingController titleControler = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(appBarTitle, style: TextStyle(color: Colors.white),),
       leading: IconButton(onPressed: () {
          Navigator.pop(context);
       }, icon: Icon(Icons.arrow_back), color:Colors.white,),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Center(
              child: Column(
            children: [
              DropdownButton(
                value: smallValue,
                items: someValue.map((String newValue) {
                  return DropdownMenuItem(
                    child: Text(newValue),
                    value: newValue,
                  );
                }).toList(),
                onChanged: <String>(dtValue) {
                  setState(() {
                    smallValue = dtValue;
                  });
                },
              ),
              TextFormField(
                controller: titleControler,
                decoration: InputDecoration(
                    hintText: 'Type your title...',
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
              ),
              Container(
                height: 10,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: 'Type the note description...',
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
              ),
              Container(height: 15,),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))
                          )
                        ),
                    onPressed: () {},
                    child: Text(
                      'Elevated Button',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
                  Container(width: 5,),
                  Expanded(
                    flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))
                          )
                        ),
                    onPressed: () {},
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
                ],
              )
            ],
          ))),
    );
  }
}
