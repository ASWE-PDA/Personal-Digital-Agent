import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_model.dart';


abstract class NewsAPI {
  late final String _apiKey;
  late String baseUrl;
  Future<List<Article>> fetchNews();

}

class NewYorkTimesNews implements NewsAPI {
  @override
  String _apiKey = "xMoAsAq9ibAxohHIg1LcD7EGu4PAduMo";

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
}
class GermanNews implements NewsAPI {
  GermanNews();
  @override
  String _apiKey = 'bb57d567ccbd4e32b33a379b0888d731';

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
}

class FinanceNews implements NewsAPI {
  FinanceNews();
  @override
  String _apiKey = 'n5Fa6vCC2s4X0NZI76FtDXf7boMpCrDDRTy2iM8u';

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
}

class TechNews implements NewsAPI {
  @override
  String _apiKey = 'bb57d567ccbd4e32b33a379b0888d731';

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


}