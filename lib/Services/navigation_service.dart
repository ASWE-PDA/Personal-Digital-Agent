import 'package:flutter/material.dart';
import 'package:luna/Screens/newsScreen.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void pushNewsScreen() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => MyNewsCardsWidget()),
    );
  }
}