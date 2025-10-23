import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ozone_erp/utils/utils.dart';

class CurrencyConversion {
  static String convertIndianRupee(String? indianRupee, String? convertTo) {
    if (indianRupee == null) return '';
    switch (convertTo) {
      case '1': // Convert to USD (US Dollar)
        return Utils().roundWithFixedDecimal(double.parse(indianRupee) / 83);
      case '2': // Return INR (Indian Rupees)
        return indianRupee;
      case '3': // Convert to EUR (Euro)
        return Utils().roundWithFixedDecimal(double.parse(indianRupee) / 90);
      case '4': // Convert to AED (United Arab Emirates Dir-ham)
        return Utils().roundWithFixedDecimal(double.parse(indianRupee) / 22.5);
      case '5': // Convert to SAR (Saudi Riyal)
        return Utils().roundWithFixedDecimal(double.parse(indianRupee) / 22.2);
      default:
        return indianRupee;
    }
  }

  static Future<Rates?> fetchRates() async {
    const String apiKey = 'c493a737ad2441bc9e195f661751458d';
    const String url = 'https://api.currencyfreaks.com/latest?apikey=$apiKey';
    try {
      Dio dio = Dio();
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        final rates = data['rates'];
        return Rates(
          usd: double.parse(rates['USD']),
          eur: double.parse(rates['EUR']),
          aed: double.parse(rates['AED']),
          sar: double.parse(rates['SAR']),
          inr: double.parse(rates['INR']),
        );
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}

class Rates {
  final double usd;
  final double eur;
  final double aed;
  final double sar;
  final double inr;

  const Rates(
      {required this.usd,
      required this.eur,
      required this.aed,
      required this.sar,
      required this.inr});
}
