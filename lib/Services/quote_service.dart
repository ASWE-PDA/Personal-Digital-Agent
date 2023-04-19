import 'dart:convert';
import 'package:http/http.dart' as http;

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

class QuoteData {
  final String quote;
  final String author;

  QuoteData({required this.quote, required this.author});
}
