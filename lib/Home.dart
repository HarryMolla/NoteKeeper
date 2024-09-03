import 'package:flutter/material.dart';
import 'package:flutter_application_1/Note_detail.dart';

class noteBook extends StatefulWidget {
  const noteBook({super.key});

  @override
  State<noteBook> createState() => _noteBookState();
}

class _noteBookState extends State<noteBook> {
  int itemCount = 10;
  int levelCount = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(
            'Notebook',
            style: TextStyle(color: Colors.white),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            return NavigatorDetial('Add note');
          },
          child: Icon(Icons.add),
          shape: OvalBorder(),
        ),
        body: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return ListTile(
                onTap: () {
                  return NavigatorDetial("Edit note");
                },
                title: Text('Main ${index + 1}'),
                subtitle: Text(
                  'This is sub',
                  style: TextStyle(color: Colors.grey),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.arrow_right),
                ),
                trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete,
                      color: Colors.grey,
                    )));
          },
        ));
  }

  void NavigatorDetial(String title) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return addNote(title);
      },
    ));
  }
}
