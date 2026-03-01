import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/news/domain/entities/news.dart';
import 'package:mobile/features/news/domain/repositories/news_repository.dart';
import 'package:mobile/features/news/presentation/cubit/news_cubit.dart';

void main() {
  group('NewsCubit', () {
    late _FakeNewsRepository repository;
    late NewsCubit cubit;

    setUp(() {
      repository = _FakeNewsRepository();
      cubit = NewsCubit(newsRepository: repository);
    });

    tearDown(() async {
      await cubit.close();
    });

    test(
      'emits loading then loaded when no cache and remote succeeds',
      () async {
        repository.refreshResult = [_sampleNews(id: 'fresh')];
        final emitted = <NewsState>[];
        final subscription = cubit.stream.listen(emitted.add);

        await cubit.loadNews();
        await Future<void>.delayed(Duration.zero);

        expect(emitted.length, 2);
        expect(emitted[0], isA<NewsLoading>());
        expect(emitted[1], isA<NewsLoaded>());
        final loaded = emitted[1] as NewsLoaded;
        expect(loaded.feed.first.id, 'fresh');
        expect(loaded.isStaleData, false);

        await subscription.cancel();
      },
    );

    test('keeps stale loaded state when refresh fails', () async {
      repository.cachedAllowExpired = [_sampleNews(id: 'stale')];
      repository.cachedFresh = null;
      repository.throwOnRefresh = true;
      final emitted = <NewsState>[];
      final subscription = cubit.stream.listen(emitted.add);

      await cubit.loadNews();
      await Future<void>.delayed(Duration.zero);

      expect(emitted.length, 2);
      final firstLoaded = emitted[0] as NewsLoaded;
      final secondLoaded = emitted[1] as NewsLoaded;
      expect(firstLoaded.feed.first.id, 'stale');
      expect(firstLoaded.isRefreshing, true);
      expect(secondLoaded.feed.first.id, 'stale');
      expect(secondLoaded.isStaleData, true);

      await subscription.cancel();
    });

    test('selectCategory filters locally with no refetch', () async {
      repository.refreshResult = [
        _sampleNews(id: 'economy', categories: const {NewsCategory.economy}),
        _sampleNews(id: 'stocks', categories: const {NewsCategory.sectors}),
      ];
      await cubit.loadNews();
      final callsBeforeSelect = repository.refreshCalls;

      cubit.selectCategory(NewsCategory.economy);

      final state = cubit.state;
      expect(state, isA<NewsLoaded>());
      expect((state as NewsLoaded).selectedCategory, NewsCategory.economy);
      expect(state.feed, hasLength(1));
      expect(state.feed.first.id, 'economy');
      expect(repository.refreshCalls, callsBeforeSelect);
    });

    test('all category returns full _allNews list', () async {
      repository.refreshResult = [
        _sampleNews(id: 'stocks', categories: const {NewsCategory.sectors}),
        _sampleNews(id: 'economy', categories: const {NewsCategory.economy}),
      ];
      await cubit.loadNews();

      cubit.selectCategory(NewsCategory.all);

      final state = cubit.state as NewsLoaded;
      expect(state.feed, hasLength(2));
    });

    test('filters economy and stocks categories', () async {
      repository.refreshResult = [
        _sampleNews(id: 'stocks-news', categories: const {NewsCategory.sectors}),
        _sampleNews(
          id: 'economy-news',
          categories: const {NewsCategory.economy},
        ),
      ];
      await cubit.loadNews();

      cubit.selectCategory(NewsCategory.economy);
      expect((cubit.state as NewsLoaded).feed.first.id, 'economy-news');

      cubit.selectCategory(NewsCategory.sectors);
      final stocksIds = (cubit.state as NewsLoaded).feed
          .map((e) => e.id)
          .toSet();
      expect(stocksIds.contains('stocks-news'), isTrue);
    });
  });
}

class _FakeNewsRepository implements NewsRepository {
  List<NewsEntity>? cachedAllowExpired;
  List<NewsEntity>? cachedFresh;
  List<NewsEntity> refreshResult = [];
  bool throwOnRefresh = false;
  int refreshCalls = 0;

  @override
  Future<List<NewsEntity>> getNews() async {
    return refreshResult;
  }

  @override
  Future<List<NewsEntity>?> getCachedNews({bool allowExpired = false}) async {
    if (allowExpired) return cachedAllowExpired;
    return cachedFresh;
  }

  @override
  Future<void> invalidateNewsCache() async {}

  @override
  Future<List<NewsEntity>> refreshNews({bool force = false}) async {
    refreshCalls++;
    if (throwOnRefresh) throw Exception('refresh failed');
    return refreshResult;
  }
}

NewsEntity _sampleNews({
  required String id,
  String title = 'Sample',
  String summary = '',
  List<String> tickers = const ['AAPL'],
  Set<NewsCategory> categories = const {NewsCategory.sectors},
}) {
  return NewsEntity(
    id: id,
    title: title,
    summary: summary,
    bannerImageUrl: null,
    author: 'N/A',
    source: 'Reuters',
    publishedAt: DateTime(2026, 3, 1),
    sentiment: NewsSentiment.neutral,
    url: 'https://example.com/$id',
    tickers: tickers,
    tickerSentiments: tickers
        .map(
          (ticker) => NewsTickerSentiment(
            ticker: ticker,
            sentiment: NewsSentiment.neutral,
            label: 'Neutral',
            score: 0,
          ),
        )
        .toList(),
    categories: categories,
  );
}

