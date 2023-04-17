import 'package:http/http.dart' as http;
import 'dart:convert';

class Article {
  String title;
  String summary;
  List<String> categories;
  String link;
  int score;

  Article({required this.title, required this.summary, required this.categories, required this.link, this.score = 0});

  factory Article.fromNYTJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      summary: json['abstract'] ?? [],
      categories: json['des_facet'] != null
          ? List<String>.from(json['des_facet'])
          : [],
      link: json['short_url'],
    );
  }

  factory Article.fromGermanJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      summary: json['description'] ?? '',
      categories: json['des_facet'] != null
          ? List<String>.from(json['des_facet'])
          : [],
      link: json['url'],
    );
  }

  factory Article.fromFinancialJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      summary: json['description'] ?? [],
      categories: json['keywords'] != null
          ? List<String>.from(json['keywords'])
          : [],
      link: json['url'],
    );
  }

  void calculateScore(List<String> preferences) {
    score = categories.fold(0, (score, category) {
      if (preferences.contains(category)) {
        return score + 1;
      }
      return score;
    });

    // add score based on title
    for (String preference in preferences) {
      if (title.toLowerCase().contains(preference.toLowerCase())) {
        score += 1;
        break;
      }
    }
  }

}
