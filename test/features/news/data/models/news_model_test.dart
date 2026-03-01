import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/news/data/models/news_model.dart';
import 'package:mobile/features/news/domain/entities/news.dart';

void main() {
  group('NewsModel.fromApiJson', () {
    test('maps API payload and defaults missing author to N/A', () {
      final model = NewsModel.fromApiJson({
        'title': 'Fed Holds Rates',
        'summary': 'The Federal Reserve kept rates unchanged.',
        'banner_image': null,
        'authors': [],
        'source': 'Reuters',
        'time_published': '20260228T154500',
        'overall_sentiment_label': 'Bullish',
        'url': 'https://example.com/news/fed',
        'ticker_sentiment': [
          {'ticker': 'SPY'},
          {'ticker': 'QQQ'},
        ],
      });

      expect(model.title, 'Fed Holds Rates');
      expect(model.author, 'N/A');
      expect(model.bannerImageUrl, isNull);
      expect(model.sentiment, NewsSentiment.bullish);
      expect(model.tickers, containsAll(['SPY', 'QQQ']));
      expect(model.publishedAt.year, 2026);
      expect(model.publishedAt.month, 2);
      expect(model.publishedAt.day, 28);
      expect(model.id, 'https://example.com/news/fed');
    });

    test('maps bearish and neutral labels correctly', () {
      final bearish = NewsModel.fromApiJson({
        'title': 'Market Slides',
        'time_published': '20260228T120000',
        'overall_sentiment_label': 'Somewhat-Bearish',
      });

      final neutral = NewsModel.fromApiJson({
        'title': 'Market Flat',
        'time_published': '20260228T120000',
        'overall_sentiment_label': 'Neutral',
      });

      expect(bearish.sentiment, NewsSentiment.bearish);
      expect(neutral.sentiment, NewsSentiment.neutral);
    });
  });

  group('NewsModel cache serialization', () {
    test('round-trips with toCacheJson and fromCacheJson', () {
      final original = NewsModel.fromApiJson({
        'title': 'Tech Rally',
        'summary': 'Large-cap tech stocks move higher.',
        'banner_image': 'https://example.com/image.jpg',
        'authors': ['Alex'],
        'source': 'Bloomberg',
        'time_published': '20260227T093000',
        'overall_sentiment_label': 'Neutral',
        'url': 'https://example.com/news/tech',
        'ticker_sentiment': [
          {'ticker': 'AAPL'},
        ],
      });

      final cached = NewsModel.fromCacheJson(original.toCacheJson());

      expect(cached.id, original.id);
      expect(cached.title, original.title);
      expect(cached.summary, original.summary);
      expect(cached.bannerImageUrl, original.bannerImageUrl);
      expect(cached.author, original.author);
      expect(cached.source, original.source);
      expect(cached.sentiment, original.sentiment);
      expect(cached.url, original.url);
      expect(cached.tickers, original.tickers);
    });
  });
}
