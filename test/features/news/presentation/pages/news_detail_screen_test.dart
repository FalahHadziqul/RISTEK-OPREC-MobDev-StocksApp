import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/news/domain/entities/news.dart';
import 'package:mobile/features/news/presentation/pages/news_detail_screen.dart';

void main() {
  NewsEntity buildArticle({
    String? imageUrl,
    String summary = 'Summary body',
    List<NewsTickerSentiment> tickerSentiments = const [
      NewsTickerSentiment(
        ticker: 'AAPL',
        sentiment: NewsSentiment.bullish,
        label: 'Bullish',
        score: 0.6,
      ),
    ],
    String url = 'https://example.com/article',
  }) {
    return NewsEntity(
      id: 'news-1',
      title: 'Market News Title',
      summary: summary,
      bannerImageUrl: imageUrl,
      author: 'N/A',
      source: 'Reuters',
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      sentiment: NewsSentiment.bullish,
      url: url,
      tickers: const ['AAPL'],
      tickerSentiments: tickerSentiments,
      categories: const {NewsCategory.sectors},
    );
  }

  testWidgets('renders core article information', (tester) async {
    final article = buildArticle(imageUrl: null);

    await tester.pumpWidget(
      MaterialApp(home: NewsDetailScreen(article: article)),
    );

    expect(find.text('Market News Title'), findsOneWidget);
    expect(find.text('Summary body'), findsOneWidget);
    expect(find.text('Market Context'), findsOneWidget);
    expect(find.textContaining('AAPL'), findsOneWidget);
    expect(find.text('Read Full Article'), findsOneWidget);
  });

  testWidgets('shows fallback states for missing image/tickers/url', (
    tester,
  ) async {
    final article = buildArticle(
      imageUrl: null,
      summary: '',
      tickerSentiments: const [],
      url: '',
    );

    await tester.pumpWidget(
      MaterialApp(home: NewsDetailScreen(article: article)),
    );

    expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    expect(find.text('Summary not available.'), findsOneWidget);
    expect(find.text('No ticker sentiment data.'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Read Full Article'),
      200,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    final buttonFinder = find.byWidgetPredicate(
      (widget) => widget is ButtonStyleButton,
    );
    final button = tester.widget<ButtonStyleButton>(buttonFinder.last);
    expect(button.onPressed, isNull);
  });
}

