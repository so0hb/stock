part of 'stock_bloc.dart';

abstract class StockEvent extends Equatable {
  const StockEvent();

  @override
  List<Object> get props => [];
}

class FetchStocks extends StockEvent {}

class SearchStocks extends StockEvent {
  final String query;

  const SearchStocks(this.query);

  @override
  List<Object> get props => [query];
}

