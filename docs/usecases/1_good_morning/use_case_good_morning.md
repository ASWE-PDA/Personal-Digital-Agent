# Use Case Description - Good Morning

| Systems | Luna, Smartphone |
| --- | --- |
| Use case | Good morning |
| Actors | User, Luna |
| Description | When being called, Luna informs about traffic status on the way to work, current weather and a quote of the day. Based on configured desired arrival time of the user, Luna will recommend the optimal time to set off (with calculation of traffic data, congestion, public transport delays, etc.) as well as suggest the best means of transport. |
| Interfaces | Luna establishes connections to the device's location interface, weather API, maps API and quotes API to request the current location, current weather, current traffic situation, best routes and the quote of the day, respectively. |
| Stimulus | User wishes good morning. / Luna sends push notification at a specific time. |
| Response | The data is sent from the repective APIs to the device and is being stored in memory. |
| Comments | This is expected to be executed once a day in the morning. |