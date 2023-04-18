import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart';

/// abstract class for use cases
/// use cases are triggered by the state machine
/// or proactively by the use case itself
abstract class UseCase {
  SpeechToText _speechToText = SpeechToText();

  /// method that is called by the state machine to execute use case
  void execute(String trigger);
}
