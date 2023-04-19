import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:luna/Services/quote_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'quote_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('QuoteService', () {
    late http.Client client;
    late QuoteService quoteService;

    setUp(() {
      client = MockClient();
      quoteService = QuoteService()..client = client;
    });

    test('getQuoteOfTheDay returns QuoteData on success', () async {
      // Arrange
      final responseBody = '[{"q":"test quote","a":"test author"}]';
      final response = http.Response(responseBody, 200);
      when(client.get(Uri.parse('https://zenquotes.io/api/today')))
          .thenAnswer((_) async => response);

      // Act
      final result = await quoteService.getQuoteOfTheDay();

      // Assert
      expect(result, isNotNull);
      expect(result!.quote, 'test quote');
      expect(result.author, 'test author');
    });

    test('getQuoteOfTheDay handles errors', () async {
      // Arrange
      when(client.get(Uri.parse('https://zenquotes.io/api/today')))
          .thenThrow(Exception('Failed to fetch quote'));

      // Act
      final result = await quoteService.getQuoteOfTheDay();

      // Assert
      expect(result, isNull);
    });
  });
}
