import 'package:flutter/material.dart';

class MyState extends StatefulWidget {
  final Widget child;

  const MyState({super.key, required this.child});

  @override
  State<MyState> createState() => _MyStateState();

  // Public method to toggle background colors
  static _MyStateState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyStateState>();
   
  }
}

class _MyStateState extends State<MyState> {
  bool isWhite = true;

  void toggleBackgroundColors() {
    setState(() {
      isWhite = !isWhite;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        scaffoldBackgroundColor: isWhite ? Colors.white : Colors.black,
      ),
      child: widget.child,
    );
  }
}
