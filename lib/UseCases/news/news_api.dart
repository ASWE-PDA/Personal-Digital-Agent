import "dart:convert";
import "package:http/http.dart" as http;
import "article.dart";
import "package:luna/environment.dart";

/// abstract class for NewsAPIs
/// gets implemented for each service
abstract class NewsAPI {
  late final String _apiKey;
  late String baseUrl;
  /// abstract method, gets implemented for each service
  Future<List<Article>> fetchNews();
}
/// NewYorkTimes Service.
/// apiKey provided by Environment.dart
class NewYorkTimesNews implements NewsAPI {
  @override
  final String _apiKey = Environment.newYorkTimesKey;

  @override
  String baseUrl = "https://api.nytimes.com/svc/topstories/v2/";

  /// generic fetching
  /// fetches 2 sections and returns the list
  @override
  Future<List<Article>> fetchNews() async {
    List<Article> returnList = [];
    List<Article> tempList;
    tempList = await fetchSection("technology");
    returnList.add(tempList[0]);
    returnList.add(tempList[1]);

    tempList = await fetchSection("sports");
    returnList.add(tempList[0]);
    returnList.add(tempList[1]);

    return returnList;
  }

  Future<List<Article>> fetchSection(String section) async {
    String advancedUrl = "$section.json?api-key=$_apiKey";
    advancedUrl = baseUrl + advancedUrl;

    final response = await http.get(Uri.parse(advancedUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(utf8.decode(response.body.codeUnits));
      final List<Article> articles = List<Article>.from(
          data['results'].map((article) => Article.fromNYTJson(article)));
      return articles;

    } else if(response.statusCode == 401){
      print("NYT: 401 Error! Passing empty String");
      return [];

    } else {
      print("Failed to load articles, returning empty list, ${response.statusCode}");
      return [];
    }
  }

  @override
  set _apiKey(String __apiKey) {
    // TODO: implement _apiKey
  }
}
class GermanNews implements NewsAPI {

  @override
  final String _apiKey = Environment.newsapiKey;

  @override
  String baseUrl = "https://newsapi.org/v2/everything?q=germany&apiKey=";

  @override
  Future<List<Article>> fetchNews() async {
    String advancedUrl = baseUrl + _apiKey;
    final response = await http.get(Uri.parse(advancedUrl));
    if (response.statusCode == 200) {

      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<Article> articles = List<Article>.from(
          data["articles"].map((article) => Article.fromGermanJson(article)));
      return articles;
    } else if(response.statusCode == 401){
      print("DE: 401 Error! Passing empty String");
      return [];

    } else {
      print("Failed to load articles, returning empty list, ${response.statusCode}");
      return [];
    }
    //return returnList;
  }

  @override
  set _apiKey(String __apiKey) {
    // TODO: implement _apiKey
  }
}

class FinanceNews implements NewsAPI {
  @override
  final String _apiKey = Environment.marketauxApiKey;

  @override
  String baseUrl = "https://api.marketaux.com/v1/news/all?filter_entities=true&language=en&api_token=";

  @override
  Future<List<Article>> fetchNews() async{
    String advancedUrl = baseUrl + _apiKey;
    final response = await http.get(Uri.parse(advancedUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<Article> articles = List<Article>.from(
          data["data"].map((article) => Article.fromFinancialJson(article)));
      print("FIN: Fetch done");
      return articles;
    } else if(response.statusCode == 401){
      print("FIN: 401 Error! Passing empty String");
      return [];

    } else {
      print("Failed to load articles, returning empty list, ${response.statusCode}");
      return [];
    }

  }

  @override
  set _apiKey(String __apiKey) {
    // TODO: implement _apiKey
  }
}

class TechNews implements NewsAPI {
  @override
  final String _apiKey = Environment.newsapiKey;

  @override
  String baseUrl = "https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=";

  @override
  Future<List<Article>> fetchNews() async {

    String advancedUrl = baseUrl + _apiKey;
    final response = await http.get(Uri.parse(advancedUrl));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<Article> articles = List<Article>.from(
          data["articles"].map((article) => Article.fromGermanJson(article)));
      return articles;
    } else if(response.statusCode == 401){
      print("TEK: 401 Error! Passing empty String");
      return [];

    } else {
      print("Failed to load articles, returning empty list, ${response.statusCode}");
      return [];
    }
  }

  @override
  set _apiKey(String __apiKey) {
    // TODO: implement _apiKey
  }
}