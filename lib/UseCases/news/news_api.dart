import "dart:convert";
import "package:http/http.dart" as http;
import "news_model.dart";
import "package:luna/environment.dart";

abstract class NewsAPI {
  late final String _apiKey;
  late String baseUrl;
  Future<List<Article>> fetchNews();

}

class NewYorkTimesNews implements NewsAPI {
  @override
  NewYorkTimesNews() : _apiKey = Environment.newYorkTimesKey;
  @override
  final String _apiKey;
  
  @override
  String baseUrl = "https://api.nytimes.com/svc/topstories/v2/";

  @override
  Future<List<Article>> fetchNews() async {
    List<Article> returnList = [];
    List<Article> tempList;
    tempList = await fetchSection('technology');
    returnList.add(tempList[0]);
    returnList.add(tempList[1]);

    tempList = await fetchSection('sports');
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
      throw Exception('Failed to load articles, ${response.statusCode}');
    }
  }

  @override
  set _apiKey(String __apiKey) {
    // TODO: implement _apiKey
  }
}
class GermanNews implements NewsAPI {
  @override
  GermanNews() : _apiKey = Environment.newsapiKey;
  @override
  final String _apiKey;

  @override
  String baseUrl = 'https://newsapi.org/v2/everything?q=germany&apiKey=';

  @override
  Future<List<Article>> fetchNews() async {
    String advancedUrl = baseUrl + _apiKey;
    final response = await http.get(Uri.parse(advancedUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(utf8.decode(response.body.codeUnits));
      final List<Article> articles = List<Article>.from(
          data['articles'].map((article) => Article.fromGermanJson(article)));
      return articles;
    } else {
      throw Exception('Failed to load articles');
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
  FinanceNews() : _apiKey = Environment.marketauxApiKey;
  @override
  final String _apiKey;
  
  @override
  String baseUrl = 'https://api.marketaux.com/v1/news/all?filter_entities=true&language=en&api_token=';

  @override
  Future<List<Article>> fetchNews() async{
    String advancedUrl = baseUrl + _apiKey;
    final response = await http.get(Uri.parse(advancedUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(utf8.decode(response.body.codeUnits));
      final List<Article> articles = List<Article>.from(
          data['data'].map((article) => Article.fromGermanJson(article)));
      print("financeFetch done");
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }

  }

  @override
  set _apiKey(String __apiKey) {
    // TODO: implement _apiKey
  }
}

class TechNews implements NewsAPI {
  @override
  TechNews() : _apiKey = Environment.newsapiKey;
  @override
  final String _apiKey;

  @override
  String baseUrl = 'https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=';

  @override
  Future<List<Article>> fetchNews() async {
    String advancedUrl = baseUrl + _apiKey;
    final response = await http.get(Uri.parse(advancedUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(utf8.decode(response.body.codeUnits));
      final List<Article> articles = List<Article>.from(
          data['articles'].map((article) => Article.fromGermanJson(article)));
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }

  @override
  set _apiKey(String __apiKey) {
    // TODO: implement _apiKey
  }


}