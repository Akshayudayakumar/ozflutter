import '../models/general_details.dart';

class FilterServices {
  String sortItems({required List<Items> items, required String value}) {
    switch (value) {
      case 'name':
        items.sort((a, b) => a.name!.compareTo(b.name!));
        return 'Sorted by Name (A-Z)';
      case 'srate':
        items.sort((a, b) => a.srate!.trim().compareTo(b.srate!.trim()));
        return 'Sorted by Selling Rate (Low to High)';
      case 'quantity':
        items.sort(
            (a, b) => int.parse(a.itemQty!).compareTo(int.parse(b.itemQty!)));
        return 'Sorted by Quantity (Low to High)';
      case 'mrp':
        items.sort((a, b) => a.mrp!.compareTo(b.mrp!));
        return 'Sorted by MRP (Low to High)';
      case 'category':
        items.sort((a, b) => a.category?.compareTo(b.category ?? '') ?? 0);
        return 'Sorted by Category';
      case 'type':
        items.sort((a, b) => a.type?.compareTo(b.type ?? '') ?? 0);
        return 'Sorted by Type';
      case 'brand':
        items.sort((a, b) => a.brandId?.compareTo(b.brandId ?? '') ?? 0);
        return 'Sorted by Brand';
      case 'mfg':
        items.sort((a, b) => a.mfgDate!.compareTo(b.mfgDate!));
        return 'Sorted by MFG (Earliest First)';
      case 'exp':
        items.sort((a, b) => a.expDate!.compareTo(b.expDate!));
        return 'Sorted by EXP (Earliest First)';
      default:
        items.sort((a, b) => a.name!.compareTo(b.name!));
        return 'Sorted by Name (A-Z)';
    }
  }

  String reverseSortItems({required List<Items> items, required String value}) {
    switch (value) {
      case 'name':
        items.sort((a, b) => b.name!.compareTo(a.name!));
        return 'Sorted by Name (Z-A)';
      case 'srate':
        items.sort((a, b) => b.srate!.trim().compareTo(a.srate!.trim()));
        return 'Sorted by Selling Rate (High to Low)';
      case 'quantity':
        items.sort(
            (a, b) => int.parse(b.itemQty!).compareTo(int.parse(a.itemQty!)));
        return 'Sorted by Quantity (High to Low)';
      case 'mrp':
        items.sort((a, b) => b.mrp!.compareTo(a.mrp!));
        return 'Sorted by MRP (High to Low)';
      case 'category':
        items.sort((a, b) => b.category?.compareTo(a.category ?? '') ?? 0);
        return 'Sorted by Category';
      case 'type':
        items.sort((a, b) => b.type?.compareTo(a.type ?? '') ?? 0);
        return 'Sorted by Type';
      case 'brand':
        items.sort((a, b) => b.brandId?.compareTo(a.brandId ?? '') ?? 0);
        return 'Sorted by Brand';
      case 'mfg':
        items.sort((a, b) => b.mfgDate!.compareTo(a.mfgDate!));
        return 'Sorted by MFG (Latest First)';
      case 'exp':
        items.sort((a, b) => b.expDate!.compareTo(a.expDate!));
        return 'Sorted by EXP (Latest First)';
      default:
        items.sort((a, b) => b.name!.compareTo(a.name!));
        return 'Sorted by Name (Z-A)';
    }
  }

  List<Items> filterByCategory(
          {required List<Items> items, required String value}) =>
      items.where((item) => item.itemCategoryId == value).toList();

  List<Items> filterByBrand(
          {required List<Items> items, required String value}) =>
      items.where((item) => item.brandId == value).toList();

  List<Items> filterByType(
          {required List<Items> items, required String value}) =>
      items.where((item) => item.type == value).toList();
}
