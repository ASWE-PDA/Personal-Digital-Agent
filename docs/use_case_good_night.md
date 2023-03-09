# Use Case Description - Good Night

| Systems | Luna, Smartphone |
| --- | --- |
| Use case | Good night |
| Actors | User, Luna |
| Description | Wenn der Use Case aufgerufen wird, frägt Luna zunächst ob und wann man am nächsten Tag geweckt werden will und stellt daraufhin einen Wecker. Dann wünscht Luna eine gute Nacht und schaltet alle Lichter aus und stellt eine angenehme Schlaftemperatur ein. Wenn der User eine Spotify Schlafplaylist hinterlegt hat, startet Luna die Playlist und schaltet sie automatisch nach einer gewissen Zeit aus.|
| Interfaces | Luna verwendet die Smart Home API um die Lichter auszuschalten und die Temperatur einzstellen und die Spotify API für das Starten der Schalfplaylist. Der Wecker wird auf dem Gerät des Nutzers gestellt.|
| Stimulus | User wünscht Gute Nacht. |
| Response | Die Daten werden an das Gerät gesendet und im Speicher hinterlegt. |
| Comments | Der Use Case wird normalerweise einmal am Tag ausgeführt. |