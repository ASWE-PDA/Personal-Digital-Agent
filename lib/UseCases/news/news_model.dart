import 'package:http/http.dart' as http;
import 'dart:convert';

class Article {
  String title;
  String summary;
  //int views;
  List<String> categories;
  String link;

  Article({required this.title, required this.summary, /*required this.views,*/ required this.categories, required this.link});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      summary: json['abstract'],
      //views: json['views'],
      categories: json['des_facet'] != null
          ? List<String>.from(json['des_facet'])
          : [],
      link: json['short_url'],
    );
  }
}
/*
Future<List<Article>> fetchNYTArticles() async {
  final String apiKey = 'xMoAsAq9ibAxohHIg1LcD7EGu4PAduMo';
  final String baseUrl = 'https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=$apiKey';
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    final List<dynamic> articlesJson = jsonDecode(response.body)['results'];
    return articlesJson.map((articleJson) => Article.fromJson(articleJson)).toList();
  } else {
    throw Exception('Failed to load articles');
  }
}

List<Article> filterArticlesByPopularity(List<Article> articles, int threshold) {
  return articles.where((article) => article.views >= threshold).toList();
}

*/