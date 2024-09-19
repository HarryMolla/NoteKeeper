import 'package:flutter/material.dart';
import 'package:flutter_application_1/Home.dart';
import 'package:flutter_application_1/Note_detail.dart';
import 'package:flutter_application_1/StateFull.dart';

void main(){
  
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyState(
        child: NoteBook()
      ),
    )
  );
}
