import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/constants/constant_routes.dart';
import 'package:mobile/core/di/injection.dart';
import 'package:mobile/features/news/domain/entities/news.dart';
import 'package:mobile/features/news/domain/repositories/news_repository.dart';
import 'package:mobile/features/news/presentation/cubit/news_cubit.dart';
import 'package:mobile/features/news/presentation/pages/news_screen.dart';

void main() {
  setUp(() async {
    await sl.reset();
    sl.registerFactory<NewsCubit>(
      () => NewsCubit(newsRepository: _FakeNewsRepository()),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('tapping news card navigates to news detail route with extra', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/news',
      routes: [
        GoRoute(path: '/news', builder: (context, state) => const NewsScreen()),
        GoRoute(
          name: ConstantRoutes.newsDetail,
          path: '/news-detail',
          builder: (context, state) {
            final article = state.extra as NewsEntity;
            return Scaffold(body: Text('Detail: ${article.id}'));
          },
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Sample Title'), findsOneWidget);
    await tester.tap(find.text('Sample Title'));
    await tester.pumpAndSettle();

    expect(find.text('Detail: news-1'), findsOneWidget);
  });
}

class _FakeNewsRepository implements NewsRepository {
  @override
  Future<List<NewsEntity>> getNews() async => _feed;

  @override
  Future<List<NewsEntity>?> getCachedNews({bool allowExpired = false}) async {
    return null;
  }

  @override
  Future<void> invalidateNewsCache() async {}

  @override
  Future<List<NewsEntity>> refreshNews({bool force = false}) async => _feed;
}

final List<NewsEntity> _feed = [
  NewsEntity(
    id: 'news-1',
    title: 'Sample Title',
    summary: 'Sample Summary',
    bannerImageUrl: null,
    author: 'N/A',
    source: 'Reuters',
    publishedAt: DateTime(2026, 3, 1, 10, 0, 0),
    sentiment: NewsSentiment.neutral,
    url: 'https://example.com/news-1',
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
  ),
];

