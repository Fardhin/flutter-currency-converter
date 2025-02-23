import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String apiKey = "a6411c32c7c3c18bebc99e8d"; // Replace with your API key
  static const String apiUrl = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/';

  // Fetch all exchange rates for a given base currency
  static Future<Map<String, double>> fetchExchangeRates(String baseCurrency) async {
    final response = await http.get(Uri.parse('$apiUrl$baseCurrency'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Map<String, double> rates = {};
      data['conversion_rates'].forEach((key, value) {
        rates[key] = value.toDouble();
      });
      return rates;
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  // Fetch available currency codes
  static Future<List<String>> fetchAvailableCurrencies() async {
    final response = await http.get(Uri.parse('$apiUrl' 'USD')); // Fetch USD rates to get all available currencies

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['conversion_rates'].keys.toList(); // Extract currency codes
    } else {
      throw Exception('Failed to load currencies');
    }
  }
}
