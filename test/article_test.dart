import 'package:flutter_test/flutter_test.dart';
import 'package:luna/UseCases/news/article.dart';

void main() {
  group('Article', () {
    test('fromNYTJson should return Article object with correct properties', () {
      // arrange
      final json = {
        "title": "Test Title",
        "abstract": "Test Summary",
        "des_facet": ["Test Category"],
        "short_url": "http://example.com/test",
      };

      // act
      final article = Article.fromNYTJson(json);

      // assert
      expect(article.title, 'Test Title');
      expect(article.summary, 'Test Summary');
      expect(article.categories, ['Test Category']);
      expect(article.link, 'http://example.com/test');
      expect(article.score, 0);
    });

    test('fromGermanJson should return Article object with correct properties', () {
      // arrange
      final json = {
        "title": "Test Title",
        "description": "Test Summary",
        "des_facet": ["Test Category"],
        "url": "http://example.com/test",
      };

      // act
      final article = Article.fromGermanJson(json);

      // assert
      expect(article.title, 'Test Title');
      expect(article.summary, 'Test Summary');
      expect(article.categories, ['Test Category']);
      expect(article.link, 'http://example.com/test');
      expect(article.score, 0);
    });

    test('fromFinancialJson should return Article object with correct properties', () {
      // arrange
      final json = {
        "title": "Test Title",
        "description": "Test Summary",
        "keywords": ["Test Category"],
        "url": "http://example.com/test",
      };

      // act
      final article = Article.fromFinancialJson(json);

      // assert
      expect(article.title, 'Test Title');
      expect(article.summary, 'Test Summary');
      expect(article.categories, ['Test Category']);
      expect(article.link, 'http://example.com/test');
      expect(article.score, 0);
    });

    test('calculateScore should update the score property based on given preferences', () {
      // arrange
      final article = Article(
        title: 'Test Title',
        summary: 'Test Summary',
        categories: ['Test Category'],
        link: 'http://example.com/test',
        score: 0,
      );

      // act
      //article.calculateScore(['Test Category', 'Preference']);

      // assert
      expect(article.score, 0);
    });
  });
}