// Mocks generated by Mockito 5.4.0 from annotations
// in luna/test/state_machine_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i9;

import 'package:flutter_tts/flutter_tts.dart' as _i2;
import 'package:luna/Services/SmartHome/bridge_model.dart' as _i3;
import 'package:luna/Services/SmartHome/smart_home_service.dart' as _i5;
import 'package:luna/Services/spotify_service.dart' as _i6;
import 'package:luna/UseCases/good_morning_model.dart' as _i7;
import 'package:luna/UseCases/good_night_model.dart' as _i4;
import 'package:luna/UseCases/good_night_use_case.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFlutterTts_0 extends _i1.SmartFake implements _i2.FlutterTts {
  _FakeFlutterTts_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBridgeModel_1 extends _i1.SmartFake implements _i3.BridgeModel {
  _FakeBridgeModel_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGoodNightModel_2 extends _i1.SmartFake
    implements _i4.GoodNightModel {
  _FakeGoodNightModel_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSmartHomeService_3 extends _i1.SmartFake
    implements _i5.SmartHomeService {
  _FakeSmartHomeService_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSpotifySdkService_4 extends _i1.SmartFake
    implements _i6.SpotifySdkService {
  _FakeSpotifySdkService_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGoodMorningModel_5 extends _i1.SmartFake
    implements _i7.GoodMorningModel {
  _FakeGoodMorningModel_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GoodNightUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGoodNightUseCase extends _i1.Mock implements _i8.GoodNightUseCase {
  MockGoodNightUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<String> get goodNightTriggerWords => (super.noSuchMethod(
        Invocation.getter(#goodNightTriggerWords),
        returnValue: <String>[],
      ) as List<String>);
  @override
  set goodNightTriggerWords(List<String>? _goodNightTriggerWords) =>
      super.noSuchMethod(
        Invocation.setter(
          #goodNightTriggerWords,
          _goodNightTriggerWords,
        ),
        returnValueForMissingStub: null,
      );
  @override
  List<String> get lightTriggerWords => (super.noSuchMethod(
        Invocation.getter(#lightTriggerWords),
        returnValue: <String>[],
      ) as List<String>);
  @override
  set lightTriggerWords(List<String>? _lightTriggerWords) => super.noSuchMethod(
        Invocation.setter(
          #lightTriggerWords,
          _lightTriggerWords,
        ),
        returnValueForMissingStub: null,
      );
  @override
  List<String> get sleepPlaylistTriggerWords => (super.noSuchMethod(
        Invocation.getter(#sleepPlaylistTriggerWords),
        returnValue: <String>[],
      ) as List<String>);
  @override
  set sleepPlaylistTriggerWords(List<String>? _sleepPlaylistTriggerWords) =>
      super.noSuchMethod(
        Invocation.setter(
          #sleepPlaylistTriggerWords,
          _sleepPlaylistTriggerWords,
        ),
        returnValueForMissingStub: null,
      );
  @override
  List<String> get alarmTriggerWords => (super.noSuchMethod(
        Invocation.getter(#alarmTriggerWords),
        returnValue: <String>[],
      ) as List<String>);
  @override
  set alarmTriggerWords(List<String>? _alarmTriggerWords) => super.noSuchMethod(
        Invocation.setter(
          #alarmTriggerWords,
          _alarmTriggerWords,
        ),
        returnValueForMissingStub: null,
      );
  @override
  List<String> get yesTriggerWords => (super.noSuchMethod(
        Invocation.getter(#yesTriggerWords),
        returnValue: <String>[],
      ) as List<String>);
  @override
  set yesTriggerWords(List<String>? _yesTriggerWords) => super.noSuchMethod(
        Invocation.setter(
          #yesTriggerWords,
          _yesTriggerWords,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i2.FlutterTts get flutterTts => (super.noSuchMethod(
        Invocation.getter(#flutterTts),
        returnValue: _FakeFlutterTts_0(
          this,
          Invocation.getter(#flutterTts),
        ),
      ) as _i2.FlutterTts);
  @override
  set flutterTts(_i2.FlutterTts? _flutterTts) => super.noSuchMethod(
        Invocation.setter(
          #flutterTts,
          _flutterTts,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.BridgeModel get bridgeModel => (super.noSuchMethod(
        Invocation.getter(#bridgeModel),
        returnValue: _FakeBridgeModel_1(
          this,
          Invocation.getter(#bridgeModel),
        ),
      ) as _i3.BridgeModel);
  @override
  set bridgeModel(_i3.BridgeModel? _bridgeModel) => super.noSuchMethod(
        Invocation.setter(
          #bridgeModel,
          _bridgeModel,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.GoodNightModel get goodNightModel => (super.noSuchMethod(
        Invocation.getter(#goodNightModel),
        returnValue: _FakeGoodNightModel_2(
          this,
          Invocation.getter(#goodNightModel),
        ),
      ) as _i4.GoodNightModel);
  @override
  set goodNightModel(_i4.GoodNightModel? _goodNightModel) => super.noSuchMethod(
        Invocation.setter(
          #goodNightModel,
          _goodNightModel,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i5.SmartHomeService get smartHomeService => (super.noSuchMethod(
        Invocation.getter(#smartHomeService),
        returnValue: _FakeSmartHomeService_3(
          this,
          Invocation.getter(#smartHomeService),
        ),
      ) as _i5.SmartHomeService);
  @override
  set smartHomeService(_i5.SmartHomeService? _smartHomeService) =>
      super.noSuchMethod(
        Invocation.setter(
          #smartHomeService,
          _smartHomeService,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i6.SpotifySdkService get spotifySdkService => (super.noSuchMethod(
        Invocation.getter(#spotifySdkService),
        returnValue: _FakeSpotifySdkService_4(
          this,
          Invocation.getter(#spotifySdkService),
        ),
      ) as _i6.SpotifySdkService);
  @override
  set spotifySdkService(_i6.SpotifySdkService? _spotifySdkService) =>
      super.noSuchMethod(
        Invocation.setter(
          #spotifySdkService,
          _spotifySdkService,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i7.GoodMorningModel get goodMorningModel => (super.noSuchMethod(
        Invocation.getter(#goodMorningModel),
        returnValue: _FakeGoodMorningModel_5(
          this,
          Invocation.getter(#goodMorningModel),
        ),
      ) as _i7.GoodMorningModel);
  @override
  set goodMorningModel(_i7.GoodMorningModel? _goodMorningModel) =>
      super.noSuchMethod(
        Invocation.setter(
          #goodMorningModel,
          _goodMorningModel,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get lastWords => (super.noSuchMethod(
        Invocation.getter(#lastWords),
        returnValue: '',
      ) as String);
  @override
  set lastWords(String? _lastWords) => super.noSuchMethod(
        Invocation.setter(
          #lastWords,
          _lastWords,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get playlistId => (super.noSuchMethod(
        Invocation.getter(#playlistId),
        returnValue: '',
      ) as String);
  @override
  set playlistId(String? _playlistId) => super.noSuchMethod(
        Invocation.setter(
          #playlistId,
          _playlistId,
        ),
        returnValueForMissingStub: null,
      );
  @override
  int get notificationId => (super.noSuchMethod(
        Invocation.getter(#notificationId),
        returnValue: 0,
      ) as int);
  @override
  set notificationId(int? _notificationId) => super.noSuchMethod(
        Invocation.setter(
          #notificationId,
          _notificationId,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i9.Future<void> loadPreferences() => (super.noSuchMethod(
        Invocation.method(
          #loadPreferences,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  void execute(String? trigger) => super.noSuchMethod(
        Invocation.method(
          #execute,
          [trigger],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i9.Future<void> schedule(
    int? hours,
    int? minutes,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #schedule,
          [
            hours,
            minutes,
          ],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<bool> checkTrigger() => (super.noSuchMethod(
        Invocation.method(
          #checkTrigger,
          [],
        ),
        returnValue: _i9.Future<bool>.value(false),
      ) as _i9.Future<bool>);
  @override
  List<String> getAllTriggerWords() => (super.noSuchMethod(
        Invocation.method(
          #getAllTriggerWords,
          [],
        ),
        returnValue: <String>[],
      ) as List<String>);
  @override
  _i9.Future<String> turnOffAllLights() => (super.noSuchMethod(
        Invocation.method(
          #turnOffAllLights,
          [],
        ),
        returnValue: _i9.Future<String>.value(''),
      ) as _i9.Future<String>);
  @override
  _i9.Future<void> askForSleepPlaylist() => (super.noSuchMethod(
        Invocation.method(
          #askForSleepPlaylist,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> startSleepPlayList() => (super.noSuchMethod(
        Invocation.method(
          #startSleepPlayList,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> askForWakeUpTime() => (super.noSuchMethod(
        Invocation.method(
          #askForWakeUpTime,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<String> setAlarm() => (super.noSuchMethod(
        Invocation.method(
          #setAlarm,
          [],
        ),
        returnValue: _i9.Future<String>.value(''),
      ) as _i9.Future<String>);
  @override
  _i9.Future<void> executeCompleteUseCase() => (super.noSuchMethod(
        Invocation.method(
          #executeCompleteUseCase,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  bool checkIfAnswerIsYes(String? answer) => (super.noSuchMethod(
        Invocation.method(
          #checkIfAnswerIsYes,
          [answer],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i9.Future<String> listenForSpeech(Duration? duration) => (super.noSuchMethod(
        Invocation.method(
          #listenForSpeech,
          [duration],
        ),
        returnValue: _i9.Future<String>.value(''),
      ) as _i9.Future<String>);
}
