import 'package:flutter/material.dart';
import 'package:luna/Screens/philips_hue_screen.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:luna/Themes/theme_model.dart';
import 'package:luna/Widgets/settings_section.dart';
import 'package:luna/Widgets/settings_widget.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  void showDeleteDialog(BuildContext context, void Function()? onPressed) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Delete shared preferences",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            content:
                Text("Are you sure you want to delete all shared preferences?"),
            actions: [
              TextButton(onPressed: onPressed, child: Text("Yes")),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      bool value = themeNotifier.isDark;
      return Consumer(builder: (context, BridgeModel userModel, child) {
        return Scaffold(
            appBar: AppBar(title: Text("Settings")),
            body: Container(
                padding: EdgeInsets.all(8.0),
                child: ListView(children: [
                  SettingsSection(title: "Common", children: [
                    SettingsWidget(
                      action: Switch.adaptive(
                        activeColor: Theme.of(context).primaryColor,
                        value: value,
                        onChanged: (newValue) {
                          setState(() => value = newValue);
                          themeNotifier.setTheme = newValue;
                        },
                      ),
                      title: "Dark Mode",
                      icon: Icon(Icons.dark_mode),
                      paddingRight: 8.0,
                    )
                  ]),
                  SettingsSection(title: "Personal Data", children: [
                    SettingsWidget(
                      preventActionOverflow: true,
                      action: (userModel.user.isEmpty || userModel.user == "")
                          ? IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SmartHomeSettingsScreen(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.arrow_forward_ios),
                              color: Theme.of(context).colorScheme.tertiary,
                            )
                          : TextButton(
                              child: Container(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  userModel.ip,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SmartHomeSettingsScreen(),
                                  ),
                                );
                              },
                            ),
                      title: "Philips Hue System",
                      icon: Icon(Icons.cast_connected_outlined),
                    ),
                    SettingsWidget(
                        action: IconButton(
                          onPressed: () {
                            showDeleteDialog(
                              context,
                              () async {
                                await themeNotifier.deleteThemePreferences();
                                await userModel.deleteBridgePreferences();
                                Navigator.pop(context);
                              },
                            );
                          },
                          icon: Icon(Icons.arrow_forward_ios),
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        title: "Delete shared preferences",
                        icon: Icon(Icons.security)),
                  ]),
                  SettingsSection(title: "About", children: [
                    SettingsWidget(
                      action: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LicensePage()),
                          );
                        },
                        icon: Icon(Icons.arrow_forward_ios),
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      title: "Licenses",
                      icon: Icon(Icons.file_copy_outlined),
                    ),
                  ]),
                ])));
      });
    });
  }
}
