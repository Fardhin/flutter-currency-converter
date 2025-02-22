import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String apiKey = "a6411c32c7c3c18bebc99e8d"; // Replace with your API key
  static const String baseUrl = "https://api.exchangerate-api.com/v4/latest/";

  static Future<List<String>> fetchAvailableCurrencies() async {
    final response = await http.get(Uri.parse("${baseUrl}USD"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data["rates"] as Map<String, dynamic>).keys.toList();
    } else {
      throw Exception("Failed to load currencies");
    }
  }

  static Future<Map<String, double>> fetchExchangeRates(String baseCurrency) async {
    final response = await http.get(Uri.parse("$baseUrl$baseCurrency"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, double>.from(data["rates"]);
    } else {
      throw Exception("Failed to load exchange rates");
    }
  }
}

