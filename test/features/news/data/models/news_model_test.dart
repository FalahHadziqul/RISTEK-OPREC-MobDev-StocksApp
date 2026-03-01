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
        'topics': [
          {'topic': 'Technology'},
          {'topic': ' Economy_Macro '},
        ],
        'ticker_sentiment': [
          {
            'ticker': 'SPY',
            'ticker_sentiment_label': 'Bullish',
            'ticker_sentiment_score': '0.43',
          },
          {'ticker': 'QQQ', 'ticker_sentiment_score': '-0.12'},
        ],
      });

      expect(model.title, 'Fed Holds Rates');
      expect(model.author, 'N/A');
      expect(model.bannerImageUrl, isNull);
      expect(model.sentiment, NewsSentiment.bullish);
      expect(model.tickers, containsAll(['SPY', 'QQQ']));
      expect(model.tickerSentiments, hasLength(2));
      expect(model.tickerSentiments.first.ticker, 'SPY');
      expect(model.tickerSentiments.first.sentiment, NewsSentiment.bullish);
      expect(model.tickerSentiments[1].ticker, 'QQQ');
      expect(model.tickerSentiments[1].sentiment, NewsSentiment.bearish);
      expect(model.categories, contains(NewsCategory.sectors));
      expect(model.categories, contains(NewsCategory.economy));
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

    test('maps explicit economy topic and ignores unknown topics', () {
      final model = NewsModel.fromApiJson({
        'title': 'Macro Commentary',
        'time_published': '20260228T120000',
        'topics': [
          {'topic': ' Economy_Macro '},
          {'topic': 'Sports'},
        ],
      });

      expect(model.categories, contains(NewsCategory.economy));
      expect(model.categories.length, 1);
    });

    test('unknown topics do not force sectors fallback', () {
      final model = NewsModel.fromApiJson({
        'title': 'Unknown Topic News',
        'time_published': '20260228T120000',
        'topics': [
          {'topic': 'Sports'},
        ],
      });

      expect(model.categories, isEmpty);
    });

    test(
      'uses article sentiment fallback when ticker sentiment data is missing',
      () {
        final model = NewsModel.fromApiJson({
          'title': 'Macro Update',
          'time_published': '20260228T120000',
          'overall_sentiment_label': 'Bearish',
          'ticker_sentiment': [
            {'ticker': 'DXY'},
          ],
        });

        expect(model.sentiment, NewsSentiment.bearish);
        expect(model.tickerSentiments, hasLength(1));
        expect(model.tickerSentiments.first.sentiment, NewsSentiment.bearish);
        expect(model.tickerSentiments.first.label, 'Bearish');
      },
    );
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
      expect(cached.tickerSentiments, original.tickerSentiments);
      expect(cached.categories, original.categories);
    });
  });

  group('NewsModel cache migration', () {
    test('prefers mapped categories from cached topics over legacy categories', () {
      final cached = NewsModel.fromCacheJson({
        'id': 'legacy-1',
        'title': 'Legacy',
        'summary': 'Legacy cache payload',
        'banner_image': null,
        'author': 'N/A',
        'source': 'Unknown',
        'published_at': '2026-03-01T12:00:00.000',
        'sentiment': 'neutral',
        'url': 'https://example.com/legacy',
        'tickers': ['CAT'],
        'categories': ['stocks'],
        'topics': ['economy_macro'],
      });

      expect(cached.categories, {NewsCategory.economy});
    });
  });
}

