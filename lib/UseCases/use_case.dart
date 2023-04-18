import 'dart:async';
import "package:speech_to_text/speech_to_text.dart" as stt;
import "package:flutter_tts/flutter_tts.dart";

/// abstract class for use cases
/// use cases are triggered by the state machine
/// or proactively by the use case itself
abstract class UseCase {
  FlutterTts flutterTts = FlutterTts();

  /// method that is called by the state machine to execute use case
  void execute(String trigger);

  /// method that triggers use case proactively
  Future<bool> checkTrigger();


  Future<String> listenForSpeech(Duration duration) async {
    // Create an instance of the speech_to_text package
    stt.SpeechToText speechToText = stt.SpeechToText();

    // Check if the device supports speech recognition
    bool isAvailable = await speechToText.initialize();
    if (!isAvailable) {
      print("Speech recognition not available");
      return "";
    }

    // Create a completer to create a future that completes with the recognized text
    Completer<String> completer = Completer<String>();

    // Start listening for speech for the specified duration
    Timer timer = Timer(duration, () async{
      await speechToText.stop();
    });
    speechToText.listen(
      partialResults: false,
      onResult: (result) async {
        print("Speech recognition result: ${result.recognizedWords}");
        completer.complete(result.recognizedWords);
        await speechToText.stop();
      },
      listenFor: duration,
    );

    // Wait for the future to complete and return the recognized text
    try {
      String recognizedText = await completer.future;
      return recognizedText;
    } catch (e) {
      print("Error: $e");
      return "";
    } finally {
      timer.cancel();
    }
  }

  Future<void> textToSpeechOutput(String output) async {

    Completer<bool> completer = Completer<bool>();
    flutterTts.speak(output);
    flutterTts.setCompletionHandler(() {
      completer.complete(true);
      print("=======================================\n\n\nCOMPLETION HANDLER DONE\n\n\n====================================");
    });
    await completer.future;
    return;
  }
}
