import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();


    return Center(
        child: Text(
          'Chat',
          style: TextStyle(fontSize: 50),
          ),
      );
  }
}