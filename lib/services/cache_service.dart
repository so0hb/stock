import 'package:shared_preferences/shared_preferences.dart';
import '../models/stock.dart';
import 'dart:convert'; // Import for jsonEncode and jsonDecode

class CacheService {
  static const String _cachedStocksKey = 'cachedStocks';

  // Cache a list of stocks
  Future<void> cacheStocks(List<Stock> stocks) async {
    final prefs = await SharedPreferences.getInstance();
    final stockJsonList = stocks.map((stock) => stock.toJson()).toList();
    prefs.setString(_cachedStocksKey, jsonEncode(stockJsonList));
  }

  // Retrieve cached stocks
  Future<List<Stock>> getCachedStocks() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cachedStocksKey);
    if (cachedData != null) {
      final stockJsonList = jsonDecode(cachedData) as List;
      return stockJsonList.map((json) => Stock.fromJson(json)).toList();
    }
    return [];
  }
}
