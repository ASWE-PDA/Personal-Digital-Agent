import 'package:flutter_test/flutter_test.dart';
import 'package:luna/UseCases/news/news_api.dart';
import 'package:luna/UseCases/news/article.dart';

class MockGermanNews extends GermanNews {
  @override
  Future<List<Article>> fetchNews() {
    // Return a fake list of articles
    return Future.value([
      Article(
        title: 'Fake article 1',
        summary: 'Summary of fake article 1',
        categories: ['Category 1', 'Category 2'],
        link: 'https://fake-article-1.com',
      ),
      Article(
        title: 'Fake article 2',
        summary: 'Summary of fake article 2',
        categories: ['Category 3', 'Category 4'],
        link: 'https://fake-article-2.com',
      ),
    ]);
  }
}

void main() {
  group('NewsAPI', ()
  {
    test('fetchNews returns a list of Articles', () async {
      final newsAPI = MockGermanNews();
      final articles = await newsAPI.fetchNews();

      expect(articles.length, equals(2));
      expect(articles[0].title, equals('Fake article 1'));
      expect(articles[0].summary, equals('Summary of fake article 1'));
      expect(articles[0].categories, equals(['Category 1', 'Category 2']));
      expect(articles[0].link, equals('https://fake-article-1.com'));

      expect(articles[1].title, equals('Fake article 2'));
      expect(articles[1].summary, equals('Summary of fake article 2'));
      expect(articles[1].categories, equals(['Category 3', 'Category 4']));
      expect(articles[1].link, equals('https://fake-article-2.com'));
    });
  });
}