import "package:flutter/material.dart";
import "package:luna/Screens/news_screen.dart";

/// Class that provides a [navigatorKey] to navigate between screens.
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void pushNewsScreen() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => MyNewsCardsWidget()),
    );
  }
}
