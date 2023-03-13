import 'package:flutter/material.dart';
import 'package:luna/Themes/theme_model.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      bool value = themeNotifier.isDark;
      return Scaffold(
          appBar: AppBar(title: Text("Settings")),
          body: Container(
              padding: EdgeInsets.all(8.0),
              child: ListView(children: [
                Container(
                    color: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.dark_mode),
                          ),
                          Expanded(flex: 2, child: Text("Dark Mode")),
                          Switch.adaptive(
                            activeColor: Theme.of(context).primaryColor,
                            value: value,
                            onChanged: (newValue) {
                              setState(() => value = newValue);
                              themeNotifier.setTheme = newValue;
                            },
                          )
                        ],
                      ),
                    )),
              ])));
    });
  }
}
