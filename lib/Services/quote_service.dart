import 'dart:convert';
import 'package:http/http.dart' as http;

/// Gets a quote of the day from the zenquotes.io API.
///
/// Returns a [QuoteData] object.
Future<QuoteData?> getQuoteOfTheDay() async {
  try {
    const String apiUrl = "https://zenquotes.io/api/today";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      Map<String, dynamic> quoteData = jsonData[0];
      return QuoteData(quote: quoteData['q'], author: quoteData['a']);
    }
  } catch (e) {
    print("Failed to fetch quote: $e");
  }
}

/// Data class for the [quote] of the day and the [author].
class QuoteData {
  final String quote;
  final String author;

  /// Constructor for the [QuoteData] class.
  QuoteData({required this.quote, required this.author});
}
