import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:luna/Services/Alarm/alarm_service.dart';
import 'package:luna/UseCases/use_case.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:luna/Services/notification_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'news_model.dart';


/// Use case for the News feature.
class NewsUseCase extends ChangeNotifier implements UseCase {
  /// Singleton instance of [NewsUseCase].
  static final instance = NewsUseCase._();

  NewsUseCase() {
    flutterTts.setLanguage("en-US");

  }

  NewsUseCase._() {
        flutterTts.setLanguage("en-US");
  }

  List<String> NewsTriggerWords = ["news", "inform me", "whats up"];
  List<String> providerTriggerWords = ["tagesschau", "hackernews", "new york times", "financial times"];
  //List<String> sleepPlaylistTriggerWords = ["music", "playlist", "spotify"];
  //List<String> alarmTriggerWords = ["alarm", "wake up", "wake me up"];

  FlutterTts flutterTts = FlutterTts();

  //BridgeModel bridgeModel = BridgeModel();
  //NewsModel newsModel = NewsModel();

  int notificationId = 2;
  List<String>? _preferences;
  final List<String> debugPreferences = ['sports', 'technology'];

  bool _showNews = false;

  bool get showNews => _showNews;

  set showNews(bool value) {
    _showNews = value;
    print("now notifying");
    notifyListeners();
  }

  List<Article> _cardArticles = [];
  List<Article> get cardArticles => _cardArticles;

  /// Loads preferences from SharedPreferences.
  Future<void> loadPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _preferences = sharedPreferences.getStringList('preferences');
  }

  @override
  void execute(String trigger) {
    if (NewsTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered news use case");
      newsRoutine();
      return;
    }
    /*else if (lightTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered light case");
      turnOffLights();
      return;
    } else if (sleepPlaylistTriggerWords
        .any((element) => trigger.contains(element))) {
      print("triggered sleep playlist case");
      startSleepPlayList();
      return;
    } else if (alarmTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered alarm case");
      setAlarm();
      return;
    }
    */
    flutterTts.speak("I don't know what you want");
    return;
  }

  Future<bool> newsRoutine() async {
    // we have different ranks of preferences:
    // big ones: German News, Technology, Finances --- these decided if certain apis are even called
    // the other ones are used to differentiate in the New York Times API#
    /*
    if (_preferences!.any((element) => element == 'German News')) {
      await pollTagesschau();
    }
    if (_preferences!.any((element) => element == 'Technology')) {
      await pollHackerNews();
    }
    if (_preferences!.any((element) => element == 'Finances')) {
      await pollFinancialTimes();
    }
    // NYT can always be evoked
    if (true) {
      await fetchNYTArticles();
    }
  */
    await flutterTts.speak("The following headlines might interest you ");

    //sortArticlesByRelevance(articles);
    _cardArticles = await fetchNYTArticles();
    //for(var art in _cardArticles) {
    //  print(art.categories);
    //}
    notifyListeners();
    await flutterTts.speak("The following headlines might interest you ");
    displayNews();

    await flutterTts.speak("use the main screen for more information!");
    return true;
  }
  void setShowNews(bool value) {
    _showNews = value;
    notifyListeners();
  }
  /*
  Future<String> pollHackerNews() async {

    return "done";
  }

  Future<String> pollFinancialTimes() async {

    return "done";
  }

  Future<String> pollTagesschau() async {

    return "done";
  }

  Future<List<String>?> gatherHeadlines() async {
    return null;
  }

  Future<bool> gatherNews() async {
    return true;
  }

  //Future<>
  List<Article> sortArticlesByRelevance(List<Article> articles) {
    dynamic temp;

    return temp;
  }
  */
  void displayNews() async {
    readNewsHeadlines();
    setShowNews(true);
  }

  Future<List<Article>> fetchSpecificNYTArticles(String section) async {
    const String apiKey = 'xMoAsAq9ibAxohHIg1LcD7EGu4PAduMo';
    String baseUrl = 'https://api.nytimes.com/svc/topstories/v2/$section.json?api-key=$apiKey';
    //final response = await http.get(Uri.parse(baseUrl));
    final response = await http.get(Uri.parse(baseUrl));
    inspect(response);
    print(response.statusCode);
    if (response.statusCode == 200) {

      //final List<dynamic> articlesJson = jsonDecode(response.body)['results'];
      //return articlesJson.map((articleJson) => Article.fromJson(articleJson)).toList();
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Article> articles = List<Article>.from(
          data['results'].map((article) => Article.fromJson(article)));
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<List<Article>> fetchNYTArticles() async{
    List<Article> returnList = [];
    List<Article> tempList;
    tempList = await fetchSpecificNYTArticles('technology');
    returnList.add(tempList[0]);
    returnList.add(tempList[1]);

    tempList = await fetchSpecificNYTArticles('sports');
    returnList.add(tempList[0]);
    returnList.add(tempList[1]);

    return returnList;
  }

  void readNewsHeadlines() async {

    for(var article in _cardArticles) {


      await flutterTts.speak(article.title);
      //await flutterTts.awaitSpeakCompletion(true);
      //await flutterTts.setSilence(1000);
    }
    await flutterTts.awaitSpeakCompletion(true);
  }


  /// Schedules a daily notification for the good night use case.
  ///
  /// The method cancels the old notificaion schedule and schedules a new one
  /// at the time defined by [hours] and [minutes].
  Future<void> schedule(int hours, int minutes) async {
    await NotificationService.instance.cancel(notificationId);

    await NotificationService.instance.scheduleAlarmNotif(
      id: notificationId,
      title: "Good Night",
      body: "It is time to go to sleep!",
      dateTime: Time(hours, minutes, 0),
    );
    print("Notification scheduled for $hours:$minutes");
  }

  @override
  Future<bool> checkTrigger() async {
    return false;
  }

  /// Returns a list of all trigger words.
  List<String> getAllTriggerWords() {
    return [
      ...NewsTriggerWords,
      //...lightTriggerWords,
      //...sleepPlaylistTriggerWords,
      //...alarmTriggerWords
    ];
  }
}


