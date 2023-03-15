# Use Case Description - News

| Systems | Luna, Device |
| --- | --- |
| Use case | News |
| Actors | User, Luna |
| Description | After getting activated, this use case collects a list of 10-20 articles that are listed on the homepages and breaking news section. Via metadata and other relevant data extraction a set of features for each article is created. The features are assigned different weights based on the users preferences. A ranked article list is created based on a similarity score that gets calculated for each article and the preferences set for the use |
| Stimulus | State machine invokes the news-use case: 1) 2)|
| Interfaces | Luna uses 4-5 different news-APIs via a GET Request to get content of different news articles. |
| Response | The summarized content of the top 2-3 articles will be read out loud. Links to the full articles (top 10) will be provided via the App-Interface in a list. |
| Comments | Steps for getting a ranked article list are merely suggestions at this point. If something easier or more efficient can be done any other way, this way should be followed instead.|