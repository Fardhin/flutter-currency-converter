import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final List<String> currencies;
  final String selectedCurrency;
  final ValueChanged<String?> onChanged;

  const CurrencyDropdown({
    required this.currencies,
    required this.selectedCurrency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencies.map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Text(currency, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
