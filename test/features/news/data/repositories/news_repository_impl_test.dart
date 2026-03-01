import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/news/data/datasources/news_local_data_source.dart';
import 'package:mobile/features/news/data/datasources/news_remote_datasource.dart';
import 'package:mobile/features/news/data/models/news_model.dart';
import 'package:mobile/features/news/data/repositories/news_repository_impl.dart';
import 'package:mobile/features/news/domain/entities/news.dart';

void main() {
  group('NewsRepositoryImpl', () {
    late _FakeLocalDataSource local;
    late _FakeRemoteDataSource remote;
    late NewsRepositoryImpl repository;

    setUp(() {
      local = _FakeLocalDataSource();
      remote = _FakeRemoteDataSource();
      repository = NewsRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: local,
      );
    });

    test('returns fresh cached news when available', () async {
      final cached = [_sampleNews(id: 'cached')];
      local.freshCache = cached;

      final result = await repository.getNews();

      expect(result, cached);
      expect(remote.fetchCallCount, 0);
    });

    test('fetches remote and caches when fresh cache missing', () async {
      final remoteFeed = [_sampleModel(id: 'remote')];
      remote.response = remoteFeed;

      final result = await repository.getNews();

      expect(result.first.id, 'remote');
      expect(local.cachedFeed, isNotNull);
      expect(local.cachedFeed!.first.id, 'remote');
      expect(remote.fetchCallCount, 1);
    });

    test('returns stale cache when remote fails', () async {
      local.staleCache = [_sampleNews(id: 'stale')];
      remote.shouldThrow = true;

      final result = await repository.getNews();

      expect(result.first.id, 'stale');
    });
  });
}

class _FakeLocalDataSource implements NewsLocalDataSource {
  List<NewsEntity>? freshCache;
  List<NewsEntity>? staleCache;
  List<NewsEntity>? cachedFeed;
  bool invalidated = false;

  @override
  Future<void> cacheNews(List<NewsEntity> feed) async {
    cachedFeed = feed;
  }

  @override
  Future<List<NewsEntity>?> getCachedNews({bool allowExpired = false}) async {
    if (allowExpired) return staleCache ?? freshCache;
    return freshCache;
  }

  @override
  Future<void> invalidateNewsCache() async {
    invalidated = true;
  }
}

class _FakeRemoteDataSource implements NewsRemoteDataSource {
  List<NewsModel> response = [];
  bool shouldThrow = false;
  int fetchCallCount = 0;

  @override
  Future<List<NewsModel>> fetchNewsSentiment({int limit = 50}) async {
    fetchCallCount++;
    if (shouldThrow) throw Exception('remote failed');
    return response;
  }
}

NewsEntity _sampleNews({required String id}) {
  return NewsEntity(
    id: id,
    title: 'Sample',
    summary: 'Summary',
    bannerImageUrl: null,
    author: 'N/A',
    source: 'Reuters',
    publishedAt: DateTime(2026, 3, 1, 10, 0, 0),
    sentiment: NewsSentiment.neutral,
    url: 'https://example.com/$id',
    tickers: const ['AAPL'],
    tickerSentiments: const [
      NewsTickerSentiment(
        ticker: 'AAPL',
        sentiment: NewsSentiment.neutral,
        label: 'Neutral',
        score: 0,
      ),
    ],
    categories: const {NewsCategory.sectors},
  );
}

NewsModel _sampleModel({required String id}) {
  return NewsModel(
    id: id,
    title: 'Sample',
    summary: 'Summary',
    bannerImageUrl: null,
    author: 'N/A',
    source: 'Reuters',
    publishedAt: DateTime(2026, 3, 1, 10, 0, 0),
    sentiment: NewsSentiment.neutral,
    url: 'https://example.com/$id',
    tickers: const ['AAPL'],
    tickerSentiments: const [
      NewsTickerSentiment(
        ticker: 'AAPL',
        sentiment: NewsSentiment.neutral,
        label: 'Neutral',
        score: 0,
      ),
    ],
    categories: const {NewsCategory.sectors},
  );
}

