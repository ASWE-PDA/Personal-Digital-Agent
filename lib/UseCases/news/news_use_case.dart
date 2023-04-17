import 'dart:developer';
import 'dart:math';
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
import 'news_api.dart';


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

  FlutterTts flutterTts = FlutterTts();
  NewYorkTimesNews newYorkTimesNews = NewYorkTimesNews();
  GermanNews germanNews = GermanNews();
  FinanceNews financeNews = FinanceNews();
  TechNews techNews = TechNews();

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
    _preferences = sharedPreferences.getStringList('preferences') ?? [];

    for(var a in _preferences! ){print('a $a');}
  }

  Future<void> deletePreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList('preferences', []);
  }

  @override
  void execute(String trigger) async {
    if (NewsTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered news use case");
      await newsRoutine();
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

    //sortArticlesByRelevance(articles);
    await loadPreferences();
    await fetchArticles();

    notifyListeners();
    await flutterTts.speak("The following headlines might interest you ");
    displayNews();

    return true;
  }

  Future<void> fetchArticles() async {
    dynamic germanArticles, nYTArticles, financeArticles, techArticles, genericArticles;
    List<Article> completeList = [];
    _preferences ??= [];
    if(_preferences != []){
      if (_preferences!.contains('German News')) {
        germanArticles = await germanNews.fetchNews();
        germanArticles = prepareList(germanArticles);
        completeList.addAll(germanArticles);
      }
      if(_preferences!.contains('Finances')) {
        financeArticles = await financeNews.fetchNews();
        financeArticles = prepareList(financeArticles);
        completeList.addAll(financeArticles);
      }
      if(_preferences!.contains('Technology')) {
        techArticles = await techNews.fetchNews();
        techArticles = prepareList(techArticles);
        completeList.addAll(techArticles);
      }
      if(_preferences!.contains('US politics')) {
        nYTArticles = await newYorkTimesNews.fetchSection('politics');
        nYTArticles = prepareList(nYTArticles);
        completeList.addAll(nYTArticles);
      }
    } else {
      genericArticles += await newYorkTimesNews.fetchSection('home');
      genericArticles = prepareList(genericArticles);
      completeList.addAll(genericArticles);
    }

    completeList = sortArticleAlgorithm(completeList);
    // Set the sorted articles to the private member _cardArticles
    _cardArticles = completeList;
    // Notify listeners of the change
    notifyListeners();
  }

  List<Article> prepareList(List<Article> inputList) {
    dynamic outputList;
    outputList = trimListByVal(inputList);
    outputList = rankArticlesInList(inputList);
    return outputList;
  }

  List<Article> trimListByVal(List<Article> inputList, [int n = 5]) {
    inputList.shuffle();
    List<Article> outputList = inputList.take(n).toList();
    return outputList;
  }

  List<Article> rankArticlesInList(List<Article> inputList) {
    if(_preferences == null) {
      print("preferences are null");
    }
    for(var element in inputList) {
      element.calculateScore(_preferences!);
    }
    return inputList;
  }

  void setShowNews(bool value) {
    _showNews = value;
    notifyListeners();
  }

  void displayNews() async {
    readNewsHeadlines();
    setShowNews(true);
  }
  /*
  Future<List<Article>> fetchSpecificNYTArticles(String section) async {
    const String apiKey = 'xMoAsAq9ibAxohHIg1LcD7EGu4PAduMo';
    String baseUrl = 'https://api.nytimes.com/svc/topstories/v2/$section.json?api-key=$apiKey';
    //final response = await http.get(Uri.parse(baseUrl));
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {

      //final List<dynamic> articlesJson = jsonDecode(response.body)['results'];
      //return articlesJson.map((articleJson) => Article.fromJson(articleJson)).toList();
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Article> articles = List<Article>.from(
          data['results'].map((article) => Article.fromNYTJson(article)));
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

  Future<List<Article>> fetchGermanNews() async {
    const String apiKey = 'bb57d567ccbd4e32b33a379b0888d731';
    String baseUrl = 'https://newsapi.org/v2/top-headlines?country=de&apiKey=$apiKey';
    //List<Article> returnList = [];
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {

      //final List<dynamic> articlesJson = jsonDecode(response.body)['results'];
      //return articlesJson.map((articleJson) => Article.fromJson(articleJson)).toList();
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Article> articles = List<Article>.from(
          data['articles'].map((article) => Article.fromGermanJson(article)));
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
    //return returnList;
  }

  Future<List<Article>> fetchItNews() async {


  }

  Future<List<Article>> fetchFinancialNews() asnyc {
    const String apiKey = 'n5Fa6vCC2s4X0NZI76FtDXf7boMpCrDDRTy2iM8u';
    String baseUrl = 'https://api.marketaux.com/v1/news/all?filter_entities=true&language=en&api_token=$apiKey';

  }
  */

  List<Article> sortArticleAlgorithm(List<Article> allArticles) {
    // Calculate the scores for each article
    for (var article in allArticles) {
      article.calculateScore(_preferences!);
    }

    // Sort the articles by score
    allArticles.sort((a, b) => b.score.compareTo(a.score));

    // If every article has a score of 0, use a random order
    if (allArticles.every((article) => article.score == 0)) {
      allArticles.shuffle();
    }

    return allArticles;
  }

  void readNewsHeadlines() async {

    for (var i = 0; i < min(_cardArticles.length, 5); i++) {
      await flutterTts.speak(_cardArticles[i].title);
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


