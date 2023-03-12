import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatPage extends StatefulWidget {
  
  bool recording = false;
  

 @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                flutterTts.speak("Hello World, may name is Luna, how can I help you?");
              }, 
              child: Text("Text to Speech"),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      print('test');
                      
                      widget.recording = !widget.recording;
                    }, 
                    icon: Icon(Icons.mic)
                  ),

                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        hintText: 'Enter a query',
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      
                    }, 
                    icon: Icon(Icons.send)
                  ),
                ],
              ),
            )
          ],
        ),
      );
  }
}