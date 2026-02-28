import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/core/endpoints/stock_endpoints.dart';
import '../models/stock_model.dart';

abstract class StockRemoteDataSource {
  Future<List<StockModel>> fetchTopGainers();
}

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  final http.Client client;

  StockRemoteDataSourceImpl({required this.client});

  String get _apiKey => dotenv.env['ALPHA_VANTAGE_API_KEY']!;

  @override
  Future<List<StockModel>> fetchTopGainers() async {
    final uri = StockEndpoints.topGainers(apiKey: _apiKey);

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Safety check: AlphaVantage sometimes returns errors in 200 OK responses
      if (data['Error Message'] != null) {
        throw Exception(data['Error Message']);
      }

      final List<dynamic> stockList = data['top_gainers'] ?? [];
      return stockList.map((json) => StockModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load stocks');
    }
  }
}
