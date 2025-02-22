import 'package:flutter/material.dart';
import '../components/currency_dropdown.dart';
import '../functions/currency_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String baseCurrency = 'USD';
  String targetCurrency = 'INR';
  String anyBase = 'EUR';
  String anyTarget = 'JPY';
  double exchangeRate = 0.0;
  double anyRate = 0.0;
  double amount = 1.0;
  double convertedAmount = 0.0;
  double anyConvertedAmount = 0.0;
  List<String> currencies = []; // Dynamic list

  @override
  void initState() {
    super.initState();
    loadCurrencies();
  }

  void loadCurrencies() async {
    try {
      List<String> fetchedCurrencies = await CurrencyService.fetchAvailableCurrencies();
      setState(() {
        currencies = fetchedCurrencies;
      });
      fetchRates();
    } catch (error) {
      print('Error fetching currencies: $error');
    }
  }

  void fetchRates() async {
    if (currencies.isEmpty) return;

    try {
      var rates = await CurrencyService.fetchExchangeRates(baseCurrency);
      var anyRates = await CurrencyService.fetchExchangeRates(anyBase);

      setState(() {
        exchangeRate = rates[targetCurrency] ?? 0.0;
        anyRate = anyRates[anyTarget] ?? 0.0;
        convertedAmount = amount * exchangeRate;
        anyConvertedAmount = amount * anyRate;
      });
    } catch (error) {
      print('Error fetching exchange rates: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Currency Converter'),
        centerTitle: true,
      ),
      body: currencies.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading until currencies are loaded
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'USD to Any Currency',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CurrencyDropdown(
              currencies: currencies,
              selectedCurrency: targetCurrency,
              onChanged: (value) {
                setState(() {
                  targetCurrency = value!;
                  fetchRates();
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Amount in USD',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 1.0;
                  fetchRates();
                });
              },
            ),
            SizedBox(height: 10),
            Text(
              'Converted Amount: $convertedAmount $targetCurrency',
              style: TextStyle(color: Colors.greenAccent, fontSize: 18),
            ),

            Divider(color: Colors.white, height: 30),

            Text(
              'Any Currency to Any Currency',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CurrencyDropdown(
                  currencies: currencies,
                  selectedCurrency: anyBase,
                  onChanged: (value) {
                    setState(() {
                      anyBase = value!;
                      fetchRates();
                    });
                  },
                ),
                Icon(Icons.swap_horiz, color: Colors.white),
                CurrencyDropdown(
                  currencies: currencies,
                  selectedCurrency: anyTarget,
                  onChanged: (value) {
                    setState(() {
                      anyTarget = value!;
                      fetchRates();
                    });
                  },
                ),
              ],
            ),

            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 1.0;
                  fetchRates();
                });
              },
            ),

            SizedBox(height: 10),
            Text(
              'Converted Amount: $anyConvertedAmount $anyTarget',
              style: TextStyle(color: Colors.greenAccent, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
