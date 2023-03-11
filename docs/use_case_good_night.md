# Use Case Description - Good Night

| Systems | Luna, Smartphone |
| --- | --- |
| Use case | Good night |
| Actors | User, Luna |
| Description | When the use case is called, Luna first asks if and when the user wants to be woken up the next day and then sets an alarm clock. Then Luna wishes a good night and turns off all lights and sets a comfortable sleeping temperature. If the user has stored a Spotify sleep playlist, Luna starts the playlist and turns it off automatically after a set time. |
| Interfaces | Lu a uses the Smart Home API to turn off the lights and set the temperature, and the Spotify API to get the sleep playlist. The alarm clock is set on the user's device.|
| Stimulus | User wishes good night. / Luna sends push notification at a specific time. |
| Response | The response data is sent to the device and is stored in the memory. |
| Comments | The use case is normally executed once a day. |