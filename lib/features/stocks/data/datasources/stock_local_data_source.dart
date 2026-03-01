import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:mobile/core/utils/market_hours.dart';
import 'package:mobile/features/stocks/domain/entities/market_movers.dart';
import '../models/company_overview_model.dart';
import '../models/price_series_model.dart';
import '../models/stock_model.dart';

/// Hive-backed local cache for stock detail data.
///
/// Uses two boxes:
/// - `company_overview` — keyed by symbol, TTL = 24 hours
/// - `price_series`     — keyed by symbol, TTL = 1h (open) / 6h (closed)
abstract class StockLocalDataSource {
  Future<MarketMovers?> getCachedMarketMovers({bool allowExpired = false});
  Future<void> cacheMarketMovers(MarketMovers movers);
  Future<void> invalidateMarketMoversCache();

  Future<CompanyOverviewModel?> getCachedOverview(String symbol);
  Future<void> cacheOverview(String symbol, CompanyOverviewModel overview);

  Future<PriceSeriesModel?> getCachedPriceSeries(String symbol);
  Future<void> cachePriceSeries(String symbol, PriceSeriesModel series);
}

class StockLocalDataSourceImpl implements StockLocalDataSource {
  static const String _marketMoversBox = 'market_movers';
  static const String _overviewBox = 'company_overview';
  static const String _priceBox = 'price_series';

  static const Duration _marketMoversTtl = Duration(minutes: 15);
  static const Duration _overviewTtl = Duration(hours: 24);
  static Duration get _priceTtl => MarketHours.marketAwareTtl(
    openTtl: const Duration(hours: 1),
    closedTtl: const Duration(hours: 6),
  );

  /// Call once during app startup (after Hive.initFlutter).
  static Future<void> openBoxes() async {
    await Hive.openBox<String>(_marketMoversBox);
    await Hive.openBox<String>(_overviewBox);
    await Hive.openBox<String>(_priceBox);
  }

  // ── Market movers ──────────────────────────────────────────────────

  @override
  Future<MarketMovers?> getCachedMarketMovers({
    bool allowExpired = false,
  }) async {
    final box = Hive.box<String>(_marketMoversBox);
    final raw = box.get('latest');
    if (raw == null) return null;

    try {
      final wrapper = json.decode(raw) as Map<String, dynamic>;
      final cachedAt = DateTime.parse(wrapper['cachedAt'] as String);
      final isExpired = DateTime.now().difference(cachedAt) > _marketMoversTtl;

      if (isExpired && !allowExpired) {
        await box.delete('latest');
        return null;
      }

      final payload = wrapper['data'] as Map<String, dynamic>? ?? {};
      final topGainersRaw = payload['top_gainers'] as List<dynamic>? ?? [];
      final activeRaw = payload['most_actively_traded'] as List<dynamic>? ?? [];

      return MarketMovers(
        topGainers: topGainersRaw
            .map(
              (item) =>
                  StockModel.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList(),
        mostActivelyTraded: activeRaw
            .map(
              (item) =>
                  StockModel.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheMarketMovers(MarketMovers movers) async {
    final box = Hive.box<String>(_marketMoversBox);
    final wrapper = {
      'cachedAt': DateTime.now().toIso8601String(),
      'data': {
        'top_gainers': movers.topGainers
            .map(
              (stock) => StockModel(
                symbol: stock.symbol,
                price: stock.price,
                changePercentage: stock.changePercentage,
              ).toJson(),
            )
            .toList(),
        'most_actively_traded': movers.mostActivelyTraded
            .map(
              (stock) => StockModel(
                symbol: stock.symbol,
                price: stock.price,
                changePercentage: stock.changePercentage,
              ).toJson(),
            )
            .toList(),
      },
    };
    await box.put('latest', json.encode(wrapper));
  }

  @override
  Future<void> invalidateMarketMoversCache() async {
    final box = Hive.box<String>(_marketMoversBox);
    await box.delete('latest');
  }

  // ── Overview ────────────────────────────────────────────────────────

  @override
  Future<CompanyOverviewModel?> getCachedOverview(String symbol) async {
    final box = Hive.box<String>(_overviewBox);
    final raw = box.get(symbol);
    if (raw == null) return null;

    final wrapper = json.decode(raw) as Map<String, dynamic>;
    final cachedAt = DateTime.parse(wrapper['cachedAt'] as String);

    if (DateTime.now().difference(cachedAt) > _overviewTtl) {
      await box.delete(symbol);
      return null;
    }

    return CompanyOverviewModel.fromJson(
      wrapper['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<void> cacheOverview(
    String symbol,
    CompanyOverviewModel overview,
  ) async {
    final box = Hive.box<String>(_overviewBox);
    final wrapper = {
      'cachedAt': DateTime.now().toIso8601String(),
      'data': overview.toJson(),
    };
    await box.put(symbol, json.encode(wrapper));
  }

  // ── Price series ──────────────────────────────────────────────────

  @override
  Future<PriceSeriesModel?> getCachedPriceSeries(String symbol) async {
    final box = Hive.box<String>(_priceBox);
    final raw = box.get(symbol);
    if (raw == null) return null;

    final wrapper = json.decode(raw) as Map<String, dynamic>;
    final cachedAt = DateTime.parse(wrapper['cachedAt'] as String);

    if (DateTime.now().difference(cachedAt) > _priceTtl) {
      await box.delete(symbol);
      return null;
    }

    return PriceSeriesModel.fromJson(wrapper['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> cachePriceSeries(String symbol, PriceSeriesModel series) async {
    final box = Hive.box<String>(_priceBox);
    final wrapper = {
      'cachedAt': DateTime.now().toIso8601String(),
      'data': series.toJson(),
    };
    await box.put(symbol, json.encode(wrapper));
  }
}
