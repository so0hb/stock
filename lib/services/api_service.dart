import 'package:dio/dio.dart';
import '../models/stock.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _apiKey = 'fe999907b556243b584c87671db653b9';

  Future<List<double>> fetchHistoricalPrices(String symbol) async {
    try {
      final response = await _dio.get(
        'https://api.marketstack.com/v1/eod',
        queryParameters: {
          'access_key': _apiKey,
          'symbols': symbol,
          'limit': 5,
        },
      );

      // Validate API response
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['data'] != null) {
        List<double> prices = [];
        for (var item in response.data['data']) {
          // Ensure the 'close' field is not null
          if (item['close'] != null) {
            prices.add(double.parse(item['close'].toString()));
          }
        }
        return prices;
      } else {
        throw Exception('Invalid API response');
      }
    } catch (e) {
      throw Exception('Failed to fetch historical prices: $e');
    }
  }

  Future<List<Stock>> fetchTopStocks() async {
    try {
      final response = await _dio.get(
        'https://api.marketstack.com/v1/tickers',
        queryParameters: {'access_key': _apiKey},
      );

      // Validate API response
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['data'] != null) {
        List<Stock> stocks = [];
        for (var item in response.data['data']) {
          stocks.add(Stock.fromJson(item));
        }
        return stocks;
      } else {
        throw Exception('Invalid API response');
      }
    } catch (e) {
      throw Exception('Failed to fetch stocks: $e');
    }
  }

  Future<List<Stock>> searchStocks(String query) async {
    try {
      final response = await _dio.get(
        'https://api.marketstack.com/v1/tickers',
        queryParameters: {
          'access_key': _apiKey,
          'search': query, // Add the search query parameter
        },
      );

      // Validate API response
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['data'] != null) {
        List<Stock> stocks = [];
        for (var item in response.data['data']) {
          stocks.add(Stock.fromJson(item));
        }
        return stocks;
      } else {
        throw Exception('Invalid API response');
      }
    } catch (e) {
      throw Exception('Failed to search stocks: $e');
    }
  }
}
