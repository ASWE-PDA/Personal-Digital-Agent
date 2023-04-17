import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _initPreferences() async {
    print("init news prefs");
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedPreferences = _prefs!.getStringList('preferences') ?? [];
    });
  }

  Future<void> deletePreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList('preferences', []);
  }

  Future<void> _savePreferences() async {
    await _prefs!.setStringList('preferences', _selectedPreferences);
    print("saved news prefs");
  }

  void _handlePreferenceSelect(String preference, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedPreferences.add(preference);
      } else {
        _selectedPreferences.remove(preference);
      }
    });
  }

  Widget _buildPreferenceList(List<String> preferenceList) {
    return ListView.builder(
      itemCount: preferenceList.length,
      itemBuilder: (context, index) {
        final preference = preferenceList[index];
        final isSelected = _selectedPreferences.contains(preference);

        return CheckboxListTile(
          title: Text(preference),
          value: isSelected,
          onChanged: (value) => _handlePreferenceSelect(preference, value!),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final preferenceList = [
      'Technology',
      //'Business',
      'US politics',
      'German News',
      //'Automobile',
      'Finances',
      //'Sports'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _savePreferences,
          )
        ],
      ),
      body: _selectedPreferences == null
          ? Center(child: CircularProgressIndicator())
          : _buildPreferenceList(preferenceList),
    );
  }
}