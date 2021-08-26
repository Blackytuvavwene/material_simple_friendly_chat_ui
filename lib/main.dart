import 'package:flutter/material.dart';
import 'package:friendly_chat/screens/chat_screen.dart';

void main() {
  runApp(MyApp());
  String name = 'blacky';
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //add some theme
    final ThemeData kDefaultTheme = ThemeData(
      primarySwatch: Colors.purple,
      accentColor: Colors.orangeAccent[400],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: kDefaultTheme,
      home: const ChatScreen(),
    );
  }
}
