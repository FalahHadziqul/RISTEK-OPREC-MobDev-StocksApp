import '../../domain/entities/market_movers.dart';
import '../../domain/entities/stock_detail.dart';
import '../../domain/repositories/stock_repository.dart';
import '../datasources/stock_local_data_source.dart';
import '../datasources/stock_remote_data_source.dart';
import '../models/company_overview_model.dart';
import '../models/price_series_model.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDataSource remoteDataSource;
  final StockLocalDataSource localDataSource;

  StockRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<MarketMovers> getMarketMovers() async {
    final cachedFresh = await localDataSource.getCachedMarketMovers();
    if (cachedFresh != null) {
      return cachedFresh;
    }

    try {
      final fresh = await remoteDataSource.fetchMarketMovers();
      await localDataSource.cacheMarketMovers(fresh);
      return fresh;
    } catch (_) {
      final cachedStale = await localDataSource.getCachedMarketMovers(
        allowExpired: true,
      );
      if (cachedStale != null) {
        return cachedStale;
      }
      rethrow;
    }
  }

  @override
  Future<MarketMovers?> getCachedMarketMovers({bool allowExpired = false}) {
    return localDataSource.getCachedMarketMovers(allowExpired: allowExpired);
  }

  @override
  Future<MarketMovers> refreshMarketMovers({bool force = false}) async {
    if (force) {
      await localDataSource.invalidateMarketMoversCache();
    }

    try {
      final fresh = await remoteDataSource.fetchMarketMovers();
      await localDataSource.cacheMarketMovers(fresh);
      return fresh;
    } catch (_) {
      final cachedStale = await localDataSource.getCachedMarketMovers(
        allowExpired: true,
      );
      if (cachedStale != null) {
        return cachedStale;
      }
      rethrow;
    }
  }

  @override
  Future<void> invalidateMarketMoversCache() {
    return localDataSource.invalidateMarketMoversCache();
  }

  @override
  Future<StockDetail> getStockDetail(String symbol) async {
    final normalizedSymbol = symbol.toUpperCase();

    CompanyOverviewModel? overview = await localDataSource.getCachedOverview(
      normalizedSymbol,
    );
    if (overview == null) {
      try {
        overview = await remoteDataSource.fetchCompanyOverview(
          normalizedSymbol,
        );
        await localDataSource.cacheOverview(normalizedSymbol, overview);
      } catch (_) {
        overview = _fallbackOverview(normalizedSymbol);
      }
    }

    PriceSeriesModel? priceSeries = await localDataSource.getCachedPriceSeries(
      normalizedSymbol,
    );
    if (priceSeries == null) {
      priceSeries = await remoteDataSource.fetchDailyTimeSeries(
        normalizedSymbol,
      );
      await localDataSource.cachePriceSeries(normalizedSymbol, priceSeries);
    }

    return StockDetail(overview: overview, priceSeries: priceSeries);
  }

  CompanyOverviewModel _fallbackOverview(String symbol) {
    return CompanyOverviewModel(
      symbol: symbol,
      name: symbol,
      description: 'No overview data available for this company.',
      exchange: 'N/A',
      sector: 'N/A',
      industry: 'N/A',
      marketCap: 'N/A',
      peRatio: 'N/A',
      dividendYield: 'N/A',
      eps: 'N/A',
      high52Week: 'N/A',
      low52Week: 'N/A',
    );
  }
}
