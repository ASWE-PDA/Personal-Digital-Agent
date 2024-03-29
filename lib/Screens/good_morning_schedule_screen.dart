import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:luna/Services/maps_service.dart';
import 'package:luna/UseCases/good_morning_model.dart';
import 'package:provider/provider.dart';

/// Screen to enter a new [time] for the good morning use case.
class GoodMorningScheduleScreen extends StatefulWidget {
  final String? time;
  const GoodMorningScheduleScreen({super.key, this.time});

  @override
  State<GoodMorningScheduleScreen> createState() =>
      _GoodMorningScheduleScreen();
}

class _GoodMorningScheduleScreen extends State<GoodMorningScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  late GoodMorningModel _goodMorningModel;
  bool _hasUnsavedChanges = false;

  // initialize with anything as it will be overwritten with actual preferences
  TimeOfDay _wakeUpTime = TimeOfDay.now();
  TimeOfDay _preferredArrivalTime = TimeOfDay.now();
  String _workAddress = "";
  // String _transportMode = GoodMorningModel.transportModes.first;

  // for autocomplete work address
  MapsService _mapsService = MapsService();
  TextEditingController _workAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// Loads the preferences from the [GoodMorningModel].
  Future<void> _loadPreferences() async {
    _goodMorningModel = await GoodMorningModel.loadPreferences();
    _wakeUpTime = await _goodMorningModel.wakeUpTime;
    _preferredArrivalTime = await _goodMorningModel.preferredArrivalTime;
    _workAddress = await _goodMorningModel.workAddress ?? "";
    // _transportMode = await _goodMorningModel.transportMode;
    _workAddressController.text = _workAddress;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GoodMorningModel>(
        builder: (context, GoodMorningModel goodMorningModel, child) {
      return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Good Morning Settings"),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text("Preferred wake-up time:"),
                          ),
                          TextButton(
                            onPressed: () async {
                              _showTimePicker(
                                context,
                                _wakeUpTime,
                                (time) => setState(() {
                                  _wakeUpTime = time;
                                  _hasUnsavedChanges = true;
                                }),
                              );
                            },
                            child: Text(formatTimeOfDay(_wakeUpTime)),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Preferred arrival time at work:"),
                          ),
                          TextButton(
                            onPressed: () => _showTimePicker(
                              context,
                              _preferredArrivalTime,
                              (time) => setState(() {
                                _preferredArrivalTime = time;
                                _hasUnsavedChanges = true;
                              }),
                            ),
                            child: Text(formatTimeOfDay(_preferredArrivalTime)),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildWorkAddressAutocomplete(),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () {
                            _onSaveButtonPressed(context);
                            _hasUnsavedChanges = false;
                          },
                          child: Text("Save"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
    });
  }

  /// Confirmation dialog asks whether to discard changes.
  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) {
      return true;
    }
    final shouldDiscardChanges = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Discard changes?"),
            content:
                Text("You have unsaved changes. Do you want to discard them?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Discard"),
              ),
            ],
          );
        });
    return shouldDiscardChanges ?? false;
  }

  /// Shows the time picker.
  Future<void> _showTimePicker(
    BuildContext context,
    TimeOfDay initialTime,
    Function(TimeOfDay) onTimeSelected,
  ) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (selectedTime != null) {
      final newTime = TimeOfDay(
        hour: selectedTime.hour,
        minute: selectedTime.minute,
      );
      onTimeSelected(newTime);
    }
  }

  /// Formats the [time] to a string.
  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formatter = DateFormat("jm"); // e.g. 5:08 AM
    return formatter.format(dateTime);
  }

  /// Builds the autocomplete widget for the work address.
  Widget _buildWorkAddressAutocomplete() {
    return TypeAheadField<Prediction>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _workAddressController,
        decoration: InputDecoration(
          labelText: "Work Address",
          hintText: "Enter your work address",
        ),
      ),
      suggestionsCallback: (pattern) async {
        return await _mapsService.getPlacePredictions(pattern);
      },
      itemBuilder: (context, prediction) {
        return ListTile(
          leading: Icon(Icons.location_on),
          title: Text(prediction.description),
        );
      },
      onSuggestionSelected: (prediction) {
        // Update the text field with the selected prediction.
        _workAddressController.text = prediction.description;
        _hasUnsavedChanges = true;
      },
    );
  }

  /// Saves the preferences to the [GoodMorningModel].
  void _onSaveButtonPressed(BuildContext context) {
    // Plausibility check if wake-up time is before preferred arrival time.
    // This is done by first converting the time to minutes and then comparing.
    if (_wakeUpTime.hour * 60 + _wakeUpTime.minute >=
        _preferredArrivalTime.hour * 60 + _preferredArrivalTime.minute) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Warning"),
            content: Text(
                "The preferred wake-up time must be before the preferred arrival time."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  setState(() {
                    _wakeUpTime = _wakeUpTime;
                    _preferredArrivalTime = _preferredArrivalTime;
                  });
                },
              ),
            ],
          );
        },
      );
      return;
    }
    _saveSettings();
    Navigator.of(context).pop(true);
  }

  /// Saves all settings to the shared preferences.
  void _saveSettings() {
    _goodMorningModel.setWakeUpTime = _wakeUpTime;
    _goodMorningModel.setPreferredArrivalTime = _preferredArrivalTime;
    _goodMorningModel.setWorkAddress = _workAddressController.text;
    // _goodMorningModel.setTransportMode = _transportMode;
  }
}
