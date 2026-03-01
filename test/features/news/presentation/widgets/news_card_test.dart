import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/news/domain/entities/news.dart';
import 'package:mobile/features/news/presentation/widgets/news_card.dart';

void main() {
  testWidgets('shows title, author and fallback image placeholder', (
    tester,
  ) async {
    final article = NewsEntity(
      id: '1',
      title: 'Market rebounds after CPI release',
      summary: 'Summary',
      bannerImageUrl: null,
      author: 'N/A',
      source: 'Reuters',
      publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
      sentiment: NewsSentiment.bullish,
      url: 'https://example.com/news/1',
      tickers: const ['SPY'],
      tickerSentiments: const [
        NewsTickerSentiment(
          ticker: 'SPY',
          sentiment: NewsSentiment.bullish,
          label: 'Bullish',
          score: 0.6,
        ),
      ],
      categories: const {NewsCategory.sectors},
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NewsCard(article: article, onTap: () {}),
        ),
      ),
    );

    expect(find.text('Market rebounds after CPI release'), findsOneWidget);
    expect(find.text('Author: N/A'), findsOneWidget);
    expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    expect(find.text('Bullish'), findsOneWidget);
  });
}

