import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile/features/news/data/models/news_model.dart';
import 'package:mobile/features/news/domain/entities/news.dart';

abstract class NewsLocalDataSource {
  Future<List<NewsEntity>?> getCachedNews({bool allowExpired = false});
  Future<void> cacheNews(List<NewsEntity> feed);
  Future<void> invalidateNewsCache();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  static const String _newsBox = 'news_feed';
  static const String _newsKey = 'latest';
  static const Duration _newsTtl = Duration(minutes: 15);

  static Future<void> openBoxes() async {
    await Hive.openBox<String>(_newsBox);
  }

  @override
  Future<List<NewsEntity>?> getCachedNews({bool allowExpired = false}) async {
    final box = Hive.box<String>(_newsBox);
    final raw = box.get(_newsKey);
    if (raw == null) return null;

    try {
      final wrapper = json.decode(raw) as Map<String, dynamic>;
      final cachedAt = DateTime.parse(wrapper['cachedAt'] as String);
      final isExpired = DateTime.now().difference(cachedAt) > _newsTtl;

      if (isExpired && !allowExpired) {
        await box.delete(_newsKey);
        return null;
      }

      final data = wrapper['data'] as Map<String, dynamic>? ?? const {};
      final feed = data['feed'] as List<dynamic>? ?? const [];
      return feed
          .whereType<Map>()
          .map(
            (item) => NewsModel.fromCacheJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheNews(List<NewsEntity> feed) async {
    final box = Hive.box<String>(_newsBox);

    final wrapper = {
      'cachedAt': DateTime.now().toIso8601String(),
      'data': {
        'feed': feed.map((item) {
          final model = NewsModel(
            id: item.id,
            title: item.title,
            summary: item.summary,
            bannerImageUrl: item.bannerImageUrl,
            author: item.author,
            source: item.source,
            publishedAt: item.publishedAt,
            sentiment: item.sentiment,
            url: item.url,
            tickers: item.tickers,
            tickerSentiments: item.tickerSentiments,
            categories: item.categories,
            topics: item is NewsModel ? item.topics : const [],
          );
          return model.toCacheJson();
        }).toList(),
      },
    };

    await box.put(_newsKey, json.encode(wrapper));
  }

  @override
  Future<void> invalidateNewsCache() async {
    final box = Hive.box<String>(_newsBox);
    await box.delete(_newsKey);
  }
}
