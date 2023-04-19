import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:luna/Themes/main_theme.dart';
import 'package:luna/Themes/theme_model.dart';
import 'package:luna/UseCases/good_morning_model.dart';
import 'package:luna/UseCases/good_night_model.dart';
import 'package:provider/provider.dart';
import 'package:alarm/alarm.dart';

import 'settings.dart';
import 'chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((context) => BridgeModel())),
      ChangeNotifierProvider(create: ((context) => GoodMorningModel())),
      ChangeNotifierProvider(create: ((context) => GoodNightModel())),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeModel(),
        child: Consumer(builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
            title: "Luna",
            darkTheme: MyThemes.darkTheme,
            themeMode: themeNotifier.currentTheme(),
            theme: MyThemes.lightTheme,
            home: MyHomePage(),
            debugShowCheckedModeBanner: false,
          );
        }));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = ChatPage();
        break;
      case 1:
        page = SettingsPage();
        break;
      default:
        throw UnimplementedError("no widget for $selectedIndex");
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                child: page,
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              padding: EdgeInsets.all(16),
              gap: 8,
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              tabs: [
                GButton(icon: Icons.chat, text: "Chat"),
                GButton(icon: Icons.settings, text: "Settings"),
              ],
            ),
          ),
        ),
      );
    });
  }
}
