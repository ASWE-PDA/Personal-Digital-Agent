import "dart:math";
import "package:flutter/foundation.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:luna/Services/Alarm/alarm_service.dart";
import "package:luna/UseCases/use_case.dart";
import "package:flutter_tts/flutter_tts.dart";
import "package:luna/Services/notification_service.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "article.dart";
import "news_api.dart";
import "package:luna/Services/navigation_service.dart";

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

  FlutterTts flutterTts = FlutterTts();
  NewYorkTimesNews newYorkTimesNews = NewYorkTimesNews();
  GermanNews germanNews = GermanNews();
  FinanceNews financeNews = FinanceNews();
  TechNews techNews = TechNews();

  int notificationId = 2;
  List<String>? _preferences;

  bool _showNews = false;
  bool get showNews => _showNews;

  set showNews(bool value) {
    _showNews = value;
    notifyListeners();
  }

  List<Article> _cardArticles = [];
  List<Article> get cardArticles => _cardArticles;

  /// Loads preferences from SharedPreferences and copies them into [_preferences].
  Future<void> loadPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _preferences = sharedPreferences.getStringList("preferences") ?? [];
  }
  /// deletes [preferences] from sharedPreferences, mainly used for debugging
  Future<void> deletePreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList("preferences", []);
  }

  /// called via statemachine
  /// calls newsRoutine and pushes NewsScreen
  @override
  void execute(String trigger) async {
    if (NewsTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered news use case");
      await newsRoutine();
      NavigationService.pushNewsScreen();
      return;
    }
    flutterTts.speak("I don't know what you want");
    return;
  }

  /// news routine
  /// gets called when news case is executed through [execute()]
  Future<bool> newsRoutine() async {
    await loadPreferences();
    await fetchArticles();
    await flutterTts.speak("The following headlines might interest you ");
    displayNews();
    return true;
  }

  Future<void> fetchArticles() async {
    dynamic germanArticles, nYTArticles, financeArticles, techArticles, genericArticles;
    List<Article> completeList = [];
    _preferences ??= [];

    if (_preferences!.contains("German News")) {
      germanArticles = await germanNews.fetchNews();
      germanArticles = prepareList(germanArticles);
      completeList.addAll(germanArticles);

    }
    if(_preferences!.contains("Finances")) {
      financeArticles = await financeNews.fetchNews();
      financeArticles = prepareList(financeArticles);
      completeList.addAll(financeArticles);
    }
    if(_preferences!.contains("Technology")) {
      techArticles = await techNews.fetchNews();
      techArticles = prepareList(techArticles);
      completeList.addAll(techArticles);
    }
    if(_preferences!.contains("US politics")) {
      nYTArticles = await newYorkTimesNews.fetchSection("politics");
      nYTArticles = prepareList(nYTArticles);
      completeList.addAll(nYTArticles);
    }
    // generic articles can always be fetched
    if (true) {
      genericArticles = await newYorkTimesNews.fetchSection("home");
      genericArticles = prepareList(genericArticles);
      completeList.addAll(genericArticles);

    }

    completeList = sortArticleAlgorithm(completeList);
    // Set the sorted articles to the private member _cardArticles
    _cardArticles = completeList;
    _cardArticles.shuffle();
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
  /// calls [readHeadlines] and
  void displayNews(){
    readNewsHeadlines();
    setShowNews(true);
  }
  /// takes input list [allArticles] and sorts them via [article.score]
  /// the [score] is calculated internally for each article
  /// returns the resulting list
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
  /// reads out the 5 most relevant (top) headlines of [_cardArticles]
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
      title: "News",
      body: "Are you interested in news updates? Go into your App and ask for news",
      dateTime: Time(hours, minutes, 0),
    );
    print("Notification scheduled for $hours:$minutes");
  }

  @override
  Future<bool> checkTrigger() async {
    return false;
  }

  @override
  Future<String> listenForSpeech(Duration duration) async {
    return "";
  }

  @override Future<void> textToSpeechOutput(String output) async {  }
}


