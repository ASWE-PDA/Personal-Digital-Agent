import 'package:flutter/services.dart';
import 'package:luna/environment.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

/// Class that uses the spoitfy sdk to communicate with the spotify remote app
/// on the device.
class SpotifySdkService {
  String clientId = "";
  SpotifySdkService() {
    // Get the spotify client id from the environment variables.
    clientId = Environment.spotifyClientId;
  }

  /// Connects to spotify remote.
  ///
  /// Returns a bool of confirmation.
  Future<bool> connect() async {
    if (clientId.isEmpty) {
      return false;
    }
    try {
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: clientId, redirectUrl: "luna://spotify-auth-callback");
      return result;
    } on PlatformException {
      print("Platform exception");
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Sets the [repeatMode] for spotify.
  Future<void> setRepeatMode(RepeatMode repeatMode) async {
    try {
      await SpotifySdk.setRepeatMode(
        repeatMode: repeatMode,
      );
    } on PlatformException {
      print("Platform exception");
    } catch (e) {
      print(e);
    }
  }

  /// Plays a playlist defined by a playlist [id] and turns off the repeating mode.
  Future<void> playPlaylist(String id) async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:playlist:$id');
      await setRepeatMode(RepeatMode.off);
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }
}
