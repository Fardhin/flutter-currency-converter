import 'package:flutter/material.dart';
import '../components/currency_dropdown.dart';
import '../functions/currency_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
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
  List<String> currencies = [];

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          title: const Text('Currency Converter',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: currencies.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'USD to Any Currency',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
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
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Amount in USD',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      amount = double.tryParse(value) ?? 1.0;
                      fetchRates();
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  'Converted Amount: $convertedAmount $targetCurrency',
                  style: const TextStyle(
                      color: Colors.greenAccent, fontSize: 18),
                ),

                const Divider(color: Colors.white, height: 30),

                const Text(
                  'Any Currency to Any Currency',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

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
                    const Icon(Icons.swap_horiz, color: Colors.white),
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
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      amount = double.tryParse(value) ?? 1.0;
                      fetchRates();
                    });
                  },
                ),

                const SizedBox(height: 10),
                Text(
                  'Converted Amount: $anyConvertedAmount $anyTarget',
                  style: const TextStyle(
                      color: Colors.greenAccent, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
