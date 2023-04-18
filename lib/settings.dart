import 'package:flutter/material.dart';
import 'package:luna/Dialogs/delete_dialog.dart';
import 'package:luna/Screens/good_morning_schedule_screen.dart';
import 'package:luna/Screens/good_night_schedule_screen.dart';
import 'package:luna/Screens/news_preferences_screen.dart';
import 'package:luna/Screens/philips_hue_screen.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:luna/Themes/theme_model.dart';
import 'package:luna/UseCases/good_morning_model.dart';
import 'package:luna/UseCases/good_night_model.dart';
import 'package:luna/Widgets/settings_section.dart';
import 'package:luna/Widgets/settings_widget.dart';
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
      return Consumer(builder: (context, BridgeModel userModel, child) {
        return Consumer(
            builder: (builder, GoodMorningModel goodMorningModel, child) {
          return Consumer(
              builder: (builder, GoodNightModel goodNightModel, child) {
            return Scaffold(
                appBar: AppBar(title: Text("Settings")),
                body: Container(
                    padding: EdgeInsets.all(8.0),
                    child: ListView(children: [
                      SettingsSection(title: "Preferences", children: [
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
                        ),
                        SettingsWidget(
                          preventActionOverflow: true,
                          action: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GoodMorningScheduleScreen(),
                                ),
                              );
                            },
                            icon: Icon(Icons.arrow_forward_ios),
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          title: "Good Morning Routine",
                          icon: Icon(Icons.wb_sunny),
                        ),
                        SettingsWidget(
                          preventActionOverflow: true,
                          action: (goodNightModel.hours == null ||
                                  goodNightModel.minutes == null)
                              ? IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GoodNightScheduleScreen(),
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
                                      goodNightModel.getPreferencesAsString(),
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
                                            GoodNightScheduleScreen(
                                          time: goodNightModel
                                              .getPreferencesAsString(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          title: "Good Night Schedule",
                          icon: Icon(Icons.bed),
                        ),
                        SettingsWidget(
                            title: "News Preferences",
                            icon: Icon(Icons.newspaper),
                            action: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PreferencesScreen(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.arrow_forward_ios),
                              color: Theme.of(context).colorScheme.tertiary,
                            ))
                      ]),
                      SettingsSection(title: "Personal Data", children: [
                        SettingsWidget(
                          preventActionOverflow: true,
                          action: (userModel.user.isEmpty ||
                                  userModel.user == "")
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
                                      "Connected",
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
                                            SmartHomeSettingsScreen(
                                                ip: userModel.ip),
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
                                    await themeNotifier
                                        .deleteThemePreferences();
                                    await userModel.deleteBridgePreferences();
                                    await goodNightModel
                                        .deleteGoodNightPreferences();
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
      });
    });
  }
}
