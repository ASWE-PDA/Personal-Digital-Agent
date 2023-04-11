import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:luna/Screens/connect_bridge_screen.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:luna/Services/notification_service.dart';
import 'package:luna/UseCases/good_night_model.dart';
import 'package:luna/UseCases/good_night_use_case.dart';
import 'package:provider/provider.dart';

/// Screen to enter a new time for the good night use case.
class GoodNightScheduleScreen extends StatefulWidget {
  final String? time;
  const GoodNightScheduleScreen({super.key, this.time});

  @override
  State<GoodNightScheduleScreen> createState() => _GoodNightScheduleScreen();
}

class _GoodNightScheduleScreen extends State<GoodNightScheduleScreen> {
  late TextEditingController _textController;

  /// Returns true if the text input field is empty.
  bool isEmpty() {
    if (_textController.text == "" || _textController.text.isEmpty) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.time);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GoodNightModel>(
        builder: (context, GoodNightModel goodNightModel, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Set Sleep Schedule"),
            actions: [
              // button to update the value of the ip address
              TextButton(
                onPressed: isEmpty()
                    ? null
                    : () async {
                        // split the string when the colon is found
                        int hours =
                            int.parse(_textController.text.split(":")[0]);
                        int minutes =
                            int.parse(_textController.text.split(":")[1]);

                        // update the preferences
                        goodNightModel.setHours = hours;
                        goodNightModel.setMinutes = minutes;

                        // update the notification schedule
                        await GoodNightUseCase.instance
                            .schedule(hours, minutes);
                        Navigator.pop(context);
                      },
                child: Text(
                  "Done",
                  style: TextStyle(
                      color: isEmpty()
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).primaryColor,
                      fontSize: 16.0),
                ),
              )
            ],
          ),
          // input field for the time
          // TODO add a time picker or a input validation
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 16.0),
                child: TextFormField(
                  controller: _textController,
                  decoration: const InputDecoration(hintText: '22:00'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ));
    });
  }
}
