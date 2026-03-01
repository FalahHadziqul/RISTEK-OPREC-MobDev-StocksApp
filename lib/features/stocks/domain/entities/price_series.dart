import 'package:equatable/equatable.dart';

/// A single OHLCV data point.
class PricePoint extends Equatable {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  const PricePoint({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  @override
  List<Object> get props => [date, open, high, low, close, volume];
}

/// Collection of daily price data for a symbol.
class PriceSeries extends Equatable {
  final String symbol;
  final List<PricePoint> points;

  const PriceSeries({required this.symbol, required this.points});

  @override
  List<Object> get props => [symbol, points];
}
