import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/core/endpoints/news_endpoints.dart';
import 'package:mobile/features/news/data/models/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> fetchNewsSentiment({int limit = 50});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  static const int _maxCallsPerMinute = 5;
  static const Duration _throttleWindow = Duration(minutes: 1);
  static final List<DateTime> _requestTimestamps = [];

  final http.Client client;

  NewsRemoteDataSourceImpl({required this.client});

  String get _apiKey => dotenv.env['ALPHA_VANTAGE_API_KEY'] ?? '';

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
  Future<List<NewsModel>> fetchNewsSentiment({int limit = 50}) async {
    if (_apiKey.isEmpty) {
      throw Exception('ALPHA_VANTAGE_API_KEY is missing.');
    }

    final uri = NewsEndpoints.newsSentiment(apiKey: _apiKey, limit: limit);
    await _waitForThrottle();
    final response = await client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load market news.');
    }

    final decoded = json.decode(response.body) as Map<String, dynamic>;

    if (decoded['Error Message'] != null) {
      throw Exception(decoded['Error Message']);
    }

    final feed = decoded['feed'] as List<dynamic>? ?? const [];
    return feed
        .whereType<Map>()
        .map((item) => NewsModel.fromApiJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
