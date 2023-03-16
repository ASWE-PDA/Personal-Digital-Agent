import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  bool recording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                onPressed: () {
                  print('test');
                  recording = !recording;
                }, 
                child: Icon(Icons.mic),
              ),
            ),
          ],
        ),
      ));
  }
}
