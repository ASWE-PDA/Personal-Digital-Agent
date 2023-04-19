import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Screen to select the news preferences.
class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  SharedPreferences? _prefs;
  late List<String> _selectedPreferences = [];

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  /// Loads the preferences from the [SharedPreferences].
  Future<void> _initPreferences() async {
    print("init news prefs");
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedPreferences = _prefs!.getStringList('preferences') ?? [];
    });
  }

  /// Deletes the preferences from the [SharedPreferences].
  Future<void> deletePreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList('preferences', []);
  }

  /// Saves the preferences to the [SharedPreferences].
  Future<void> _savePreferences() async {
    await _prefs!.setStringList('preferences', _selectedPreferences);
    print("saved news prefs");
    Navigator.of(context).pop();
  }

  /// Handles the selection of a preference.
  void _handlePreferenceSelect(String preference, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedPreferences.add(preference);
      } else {
        _selectedPreferences.remove(preference);
      }
    });
  }

  /// Builds the list of preferences.
  Widget _buildPreferenceList(List<String> preferenceList) {
    return ListView.builder(
      itemCount: preferenceList.length + 1,
      itemBuilder: (context, index) {
        // add save button at the end
        if (index == preferenceList.length) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: ElevatedButton(
                onPressed: _savePreferences,
                child: Text("Save"),
              ));
        } else {
          final preference = preferenceList[index];
          final isSelected = _selectedPreferences.contains(preference);
          return CheckboxListTile(
            title: Text(preference),
            value: isSelected,
            checkColor: Colors.green,
            onChanged: (value) => _handlePreferenceSelect(preference, value!),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final preferenceList = [
      'Technology',
      'US politics',
      'German News',
      'Finances',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: _selectedPreferences == null
          ? Center(child: CircularProgressIndicator())
          : _buildPreferenceList(preferenceList),
    );
  }
}
