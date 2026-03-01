import '../entities/market_movers.dart';
import '../entities/stock_detail.dart';

abstract class StockRepository {
  Future<MarketMovers> getMarketMovers();
  Future<MarketMovers?> getCachedMarketMovers({bool allowExpired = false});
  Future<MarketMovers> refreshMarketMovers({bool force = false});
  Future<void> invalidateMarketMoversCache();
  Future<StockDetail> getStockDetail(String symbol);
}
