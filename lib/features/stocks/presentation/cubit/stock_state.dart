part of 'stock_cubit.dart';

abstract class StockState extends Equatable {
  const StockState();

  @override
  List<Object> get props => [];
}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class StockLoaded extends StockState {
  final List<StockEntity> topGainers;
  final List<StockEntity> mostActivelyTraded;
  final bool isRefreshing;
  final bool isStaleData;

  const StockLoaded({
    required this.topGainers,
    required this.mostActivelyTraded,
    this.isRefreshing = false,
    this.isStaleData = false,
  });

  @override
  List<Object> get props => [
    topGainers,
    mostActivelyTraded,
    isRefreshing,
    isStaleData,
  ];
}

class StockError extends StockState {
  final String message;

  const StockError(this.message);

  @override
  List<Object> get props => [message];
}
