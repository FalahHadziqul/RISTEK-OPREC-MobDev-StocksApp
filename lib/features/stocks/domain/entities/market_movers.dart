import 'package:equatable/equatable.dart';
import 'stock_entity.dart';

/// Holds both top gainers and most actively traded stocks
/// from a single AlphaVantage TOP_GAINERS_LOSERS API call.
class MarketMovers extends Equatable {
  final List<StockEntity> topGainers;
  final List<StockEntity> mostActivelyTraded;

  const MarketMovers({
    required this.topGainers,
    required this.mostActivelyTraded,
  });

  @override
  List<Object> get props => [topGainers, mostActivelyTraded];
}
