import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mobile/features/news/data/datasources/news_local_data_source.dart';
import 'package:mobile/features/news/domain/entities/news.dart';

void main() {
  late Directory tempDir;
  late NewsLocalDataSourceImpl dataSource;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('news_local_ds_test');
    Hive.init(tempDir.path);
    await NewsLocalDataSourceImpl.openBoxes();
  });

  setUp(() async {
    dataSource = NewsLocalDataSourceImpl();
    await Hive.box<String>('news_feed').clear();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  NewsEntity sampleNews() {
    return NewsEntity(
      id: 'news-1',
      title: 'Sample Title',
      summary: 'Sample Summary',
      bannerImageUrl: null,
      author: 'N/A',
      source: 'Reuters',
      publishedAt: DateTime(2026, 3, 1, 10, 0, 0),
      sentiment: NewsSentiment.neutral,
      url: 'https://example.com/sample',
      tickers: const ['AAPL'],
    );
  }

  test('cacheNews then getCachedNews returns stored feed', () async {
    await dataSource.cacheNews([sampleNews()]);

    final cached = await dataSource.getCachedNews();

    expect(cached, isNotNull);
    expect(cached, hasLength(1));
    expect(cached!.first.title, 'Sample Title');
    expect(cached.first.author, 'N/A');
  });

  test('allowExpired true returns stale cached feed', () async {
    final box = Hive.box<String>('news_feed');
    final publishedAt = DateTime.now().toIso8601String();
    final stale = {
      'cachedAt': DateTime.now()
          .subtract(const Duration(minutes: 20))
          .toIso8601String(),
      'data': {
        'feed': [
          {
            'id': 'news-stale',
            'title': 'Stale News',
            'summary': '',
            'banner_image': null,
            'author': 'N/A',
            'source': 'Reuters',
            'published_at': publishedAt,
            'sentiment': 'neutral',
            'url': '',
            'tickers': <String>[],
          },
        ],
      },
    };
    await box.put('latest', jsonEncode(stale));

    final withExpired = await dataSource.getCachedNews(allowExpired: true);
    final withoutExpired = await dataSource.getCachedNews();

    expect(withExpired, isNotNull);
    expect(withExpired!.first.id, 'news-stale');
    expect(withoutExpired, isNull);
  });
}
