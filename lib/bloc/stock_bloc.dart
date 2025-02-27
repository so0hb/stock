import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/stock.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  StockBloc() : super(StockInitial()) {
    on<FetchStocks>((event, emit) async {
      emit(StockLoading());
      try {
        final stocks = await _apiService.fetchTopStocks();
        await _cacheService.cacheStocks(stocks); // Cache the fetched data
        emit(StockLoaded(stocks));
      } catch (e) {
        // If offline, fetch cached data
        final cachedStocks = await _cacheService.getCachedStocks();
        if (cachedStocks.isNotEmpty) {
          emit(StockLoaded(cachedStocks,
              isCached: true)); // Indicate cached data
        } else {
          emit(StockError('Failed to fetch stocks: $e'));
        }
      }
    });

    on<SearchStocks>((event, emit) async {
      emit(StockLoading());
      try {
        final stocks = await _apiService.searchStocks(event.query);
        await _cacheService.cacheStocks(stocks); // Cache the searched data
        emit(StockLoaded(stocks));
      } catch (e) {
        // If offline, fetch cached data
        final cachedStocks = await _cacheService.getCachedStocks();
        if (cachedStocks.isNotEmpty) {
          emit(StockLoaded(cachedStocks,
              isCached: true)); // Indicate cached data
        } else {
          emit(StockError('Failed to search stocks: $e'));
        }
      }
    });
  }
}
