import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/core/endpoints/stock_endpoints.dart';
import 'package:mobile/features/stocks/domain/entities/market_movers.dart';
import '../models/company_overview_model.dart';
import '../models/price_series_model.dart';
import '../models/stock_model.dart';

abstract class StockRemoteDataSource {
  Future<MarketMovers> fetchMarketMovers();
  Future<CompanyOverviewModel> fetchCompanyOverview(String symbol);
  Future<PriceSeriesModel> fetchDailyTimeSeries(String symbol);
}

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  final http.Client client;
  static const int _maxCallsPerMinute = 5;
  static const Duration _throttleWindow = Duration(minutes: 1);
  static final List<DateTime> _requestTimestamps = [];

  StockRemoteDataSourceImpl({required this.client});

  String get _apiKey => dotenv.env['ALPHA_VANTAGE_API_KEY']!;

  Future<void> _waitForThrottle() async {
    while (true) {
      final now = DateTime.now();
      _requestTimestamps.removeWhere(
        (timestamp) => now.difference(timestamp) >= _throttleWindow,
      );

      if (_requestTimestamps.length < _maxCallsPerMinute) {
        _requestTimestamps.add(now);
        return;
      }

      final oldest = _requestTimestamps.first;
      final waitFor = _throttleWindow - now.difference(oldest);
      await Future.delayed(
        waitFor.isNegative
            ? const Duration(milliseconds: 10)
            : waitFor + const Duration(milliseconds: 10),
      );
    }
  }

  @override
  Future<MarketMovers> fetchMarketMovers() async {
    final uri = StockEndpoints.topGainers(apiKey: _apiKey);
    await _waitForThrottle();
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data['Error Message'] != null) {
        throw Exception(data['Error Message']);
      }
      if (data['Information'] != null) {
        throw Exception(data['Information']);
      }
      if (data['Note'] != null) {
        throw Exception(data['Note']);
      }

      final List<dynamic> gainersList = data['top_gainers'] ?? [];
      final List<dynamic> activeList = data['most_actively_traded'] ?? [];

      return MarketMovers(
        topGainers: gainersList.map((j) => StockModel.fromJson(j)).toList(),
        mostActivelyTraded: activeList
            .map((j) => StockModel.fromJson(j))
            .toList(),
      );
    } else {
      throw Exception('Failed to load stocks');
    }
  }

  @override
  Future<CompanyOverviewModel> fetchCompanyOverview(String symbol) async {
    final uri = StockEndpoints.companyOverview(symbol: symbol, apiKey: _apiKey);
    await _waitForThrottle();
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data['Error Message'] != null) {
        throw Exception(data['Error Message']);
      }
      if (data.isEmpty || data['Symbol'] == null) {
        throw Exception('No overview data found for $symbol');
      }

      return CompanyOverviewModel.fromJson(data);
    } else {
      throw Exception('Failed to load company overview');
    }
  }

  @override
  Future<PriceSeriesModel> fetchDailyTimeSeries(String symbol) async {
    final uri = StockEndpoints.dailyTimeSeries(symbol: symbol, apiKey: _apiKey);
    await _waitForThrottle();
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data['Error Message'] != null) {
        throw Exception(data['Error Message']);
      }

      return PriceSeriesModel.fromJson(data);
    } else {
      throw Exception('Failed to load price data');
    }
  }
}
