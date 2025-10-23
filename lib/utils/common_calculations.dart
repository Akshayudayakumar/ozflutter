import 'package:ozone_erp/utils/utils.dart';

import '../data/app_data.dart';
import '../models/device_details.dart';

class CommonCalculations {
  /// Applies GST and CESS to the given amount based on the provided tax rates.
  ///
  /// This function calculates and applies both **GST** and **CESS** to the given
  /// [amount] based on the rates provided in the [tax] object.
  ///
  /// - The **GST rate** is extracted from `tax.gst`.
  /// - The **CESS rate** is extracted from `tax.cesPercent`.
  /// - If tax is already included (`AppData().getTaxInclude()` returns `true`),
  ///   the function returns the original amount without modification.
  /// - Otherwise, the **GST amount** is calculated as `amount * (taxRate / 100)`,
  ///   and the **CESS amount** is calculated as `gstAmount * (cesRate / 100)`.
  ///
  /// The function then returns the final amount including GST and CESS.
  ///
  /// ### Example:
  /// ```dart
  /// Tax tax = Tax(gst: 18, cesPercent: 2);
  /// num amount = 1000;
  ///
  /// num finalAmount = CommonCalculations.applyTax(amount: amount, tax: tax);
  ///
  /// print(finalAmount); // 1183.6 if tax is not included
  /// ```
  ///
  /// - [amount]: The original taxable amount.
  /// - [tax]: An instance of `Tax` containing GST and CESS rates.
  /// - Returns: The final amount after applying GST and CESS, or the original
  ///   amount if tax is already included.
  static num applyTax({required num amount, required Tax tax}) {
    double taxRate = double.tryParse(tax.gst?.toString() ?? '0') ?? 0;
    double cesRate = double.tryParse(tax.cesPercent?.toString() ?? '0') ?? 0;
    if (AppData().getTaxInclude()) {
      // If tax is already included, return the amount as is
      return amount;
    } else {
      // Apply both tax and cess
      double taxAmount = amount * (taxRate / 100);
      double cesAmount = taxAmount * (cesRate / 100);
      return amount + taxAmount + cesAmount;
    }
  }

  static const String taxRate = 'taxRate';
  static const String cesRate = 'cesRate';
  static const String taxAmt = 'taxAmt';
  static const String cesAmt = 'cesAmt';

  /// Calculates GST and CESS based on the given amount and tax rates.
  ///
  /// This function takes an [amount] and a [Tax] object, then computes
  /// the GST amount and CESS amount based on the provided rates.
  ///
  /// - The **GST rate** is extracted from `tax.gst`.
  /// - The **CESS rate** is extracted from `tax.cesPercent`.
  /// - The **GST amount** is calculated as `amount * (taxRate / 100)`.
  /// - The **CESS amount** is calculated as `gstAmount * (cesRate / 100)`.
  ///
  /// The function returns a `Map<String, double>` containing:
  /// - `'taxRate'`: The GST rate.
  /// - `'cesRate'`: The CESS rate.
  /// - `'taxAmt'`: The calculated GST amount.
  /// - `'cesAmt'`: The calculated CESS amount.
  ///
  /// ### Example:
  /// ```dart
  /// Tax tax = Tax(gst: 18, cesPercent: 2);
  /// double amount = 1000;
  /// Map<String, double> result = CommonCalculations.getGstAndCes(amount: amount, tax: tax);
  ///
  /// print(result['taxRate']);  // 18.0
  /// print(result['cesRate']);  // 2.0
  /// print(result['taxAmt']);   // 180.0
  /// print(result['cesAmt']);   // 3.6
  /// ```
  ///
  /// - [amount]: The total taxable amount.
  /// - [tax]: An instance of `Tax` containing GST and CESS rates.
  /// - Returns: A `Map<String, double>` with tax and cess calculations.
  static Map<String, double> getGstAndCes(
      {required num amount, required Tax tax}) {
    Map<String, double> map = {};
    double taxRate = double.tryParse(tax.gst?.toString() ?? '0') ?? 0;
    double cesRate = double.tryParse(tax.cesPercent?.toString() ?? '0') ?? 0;
    double taxAmount = amount * (taxRate / 100);
    double cesAmount = taxAmount * (cesRate / 100);
    map[CommonCalculations.taxRate] = taxRate;
    map[CommonCalculations.cesRate] = cesRate;
    map[taxAmt] = taxAmount;
    map[cesAmt] = cesAmount;
    return map;
  }

  static num calculateTotalRate(
      {required String rate, required String discount, required Tax tax}) {
    print(tax.toJson());
    num valueToReturn = applyTax(
        amount: Utils().roundIfWhole(num.parse(rate.isEmpty ? "0" : rate) -
            num.parse(discount.isEmpty ? "0" : discount)),
        tax: tax);
    return valueToReturn;
  }

  static num calculateDiscountPercentage(String value, String rate) {
    if (value.isNotEmpty && rate.isNotEmpty) {
      return (Utils()
          .roundIfWhole((double.parse(value) / double.parse(rate)) * 100));
    } else {
      return 0;
    }
  }

  static num convertToDiscountValue(String value, String rate) {
    if (value.isNotEmpty && rate.isNotEmpty) {
      return (Utils()
          .roundIfWhole((double.parse(value) / 100) * double.parse(rate)));
    } else {
      return 0;
    }
  }

  static const String before = 'before';
  static const String after = 'after';
  static const String isolate = 'isolate';
  static const String roundOff = 'round_off';

  /// Computes the amount before and after applying GST and CESS.
  ///
  /// This function calculates the amount **before tax**, **after tax**, and the
  /// **isolated tax amount** based on the given [rate] and [tax].
  ///
  /// - `'before'`: The original amount before tax.
  /// - `'after'`: The amount after applying GST and CESS.
  /// - `'isolate'`: The tax amount (difference between `after` and `before`).
  ///
  /// ### Example:
  /// ```dart
  /// Tax tax = Tax(gst: 18, cesPercent: 2);
  /// Map<String, String> result = CommonCalculations.beforeAndAfterTax('1000', tax);
  ///
  /// print(result['before']);   // "1000"
  /// print(result['after']);    // "1183.6"
  /// print(result['isolate']); // "183.6"
  /// ```
  ///
  /// - [rate]: The original amount as a `String`.
  /// - [tax]: An instance of `Tax` containing GST and CESS rates.
  /// - Returns: A `Map<String, String>` with amounts before tax, after tax, and the isolated tax amount.
  static Map<String, String> beforeAndAfterTax(String rate, Tax tax) {
    Map<String, String> map = {};
    map[before] = rate;
    map[after] = applyTax(amount: num.parse(rate), tax: tax).toString();
    num iso = (num.parse(map[after]!) - num.parse(map[before]!));
    String roundedIso = Utils().roundWithFixedDecimal(iso);
    double round = double.parse(roundedIso) - iso;
    map[isolate] = roundedIso;
    map[roundOff] = Utils().roundWithFixedDecimal(round);
    return map;
  }

  static num percentToValue(num percent, num total) {
    return (percent / 100) * total;
  }

  static num valueToPercent(num value, num total) {
    return (value / total) * 100;
  }
}
