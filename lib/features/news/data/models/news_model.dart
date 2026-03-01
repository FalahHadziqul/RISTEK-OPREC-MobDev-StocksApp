import 'package:mobile/features/news/domain/entities/news.dart';
import 'package:mobile/features/news/domain/utils/news_topic_mapper.dart';

class NewsModel extends NewsEntity {
  final List<String> topics;

  const NewsModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.bannerImageUrl,
    required super.author,
    required super.source,
    required super.publishedAt,
    required super.sentiment,
    required super.url,
    required super.tickers,
    required super.tickerSentiments,
    required super.categories,
    this.topics = const [],
  });

  factory NewsModel.fromApiJson(Map<String, dynamic> json) {
    final rawTitle = (json['title'] as String? ?? '').trim();
    final rawTime = (json['time_published'] as String? ?? '').trim();
    final rawUrl = (json['url'] as String? ?? '').trim();
    final summary = (json['summary'] as String? ?? '').trim();
    final source = _asNonEmptyString(json['source']) ?? 'Unknown';

    final title = rawTitle.isEmpty ? 'Untitled News' : rawTitle;
    final publishedAt = _parsePublishedAt(rawTime);
    final url = rawUrl;
    final id = url.isNotEmpty ? url : '$title|$rawTime';
    final articleSentiment = _parseSentiment(
      (json['overall_sentiment_label'] as String? ?? '').trim(),
    );
    final tickerSentiments = _parseTickerSentiments(
      json['ticker_sentiment'],
      articleSentiment,
    );
    final tickers = tickerSentiments
        .map((item) => item.ticker)
        .toSet()
        .toList();
    final topics = _parseApiTopics(json['topics']);
    final categories = NewsTopicMapper.mapTopicsToCategories(topics);

    return NewsModel(
      id: id,
      title: title,
      summary: summary,
      bannerImageUrl: _asNonEmptyString(json['banner_image']),
      author: _resolveAuthor(json['authors']),
      source: source,
      publishedAt: publishedAt,
      sentiment: articleSentiment,
      url: url,
      tickers: tickers,
      tickerSentiments: tickerSentiments,
      categories: categories,
      topics: topics,
    );
  }

  factory NewsModel.fromCacheJson(Map<String, dynamic> json) {
    final articleSentiment = _parseSentimentFromCache(
      json['sentiment'] as String?,
    );
    final tickerSentiments = _parseTickerSentimentsFromCache(
      json['ticker_sentiments'],
      articleSentiment,
    );
    final cachedTopics = _parseCachedTopics(json['topics']);
    final cachedCategories = _parseCachedCategories(json['categories']);
    final legacyTickers = (json['tickers'] as List<dynamic>? ?? const [])
        .map((item) => item.toString())
        .where((item) => item.trim().isNotEmpty)
        .map((item) => item.trim().toUpperCase())
        .toList();
    final resolvedTickers = tickerSentiments.isNotEmpty
        ? tickerSentiments.map((item) => item.ticker).toSet().toList()
        : legacyTickers;
    final mappedCategories = NewsTopicMapper.mapTopicsToCategories(cachedTopics);
    final resolvedCategories = cachedTopics.isNotEmpty
        ? mappedCategories
        : cachedCategories;

    return NewsModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled News',
      summary: json['summary'] as String? ?? '',
      bannerImageUrl: _asNonEmptyString(json['banner_image']),
      author: (json['author'] as String? ?? '').trim().isEmpty
          ? 'N/A'
          : (json['author'] as String).trim(),
      source: (json['source'] as String? ?? '').trim().isEmpty
          ? 'Unknown'
          : (json['source'] as String).trim(),
      publishedAt: _parseIsoTime(json['published_at'] as String?),
      sentiment: articleSentiment,
      url: (json['url'] as String? ?? '').trim(),
      tickers: resolvedTickers,
      tickerSentiments: tickerSentiments,
      categories: resolvedCategories,
      topics: cachedTopics,
    );
  }

  Map<String, dynamic> toCacheJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'banner_image': bannerImageUrl,
      'author': author,
      'source': source,
      'published_at': publishedAt.toIso8601String(),
      'sentiment': sentiment.name,
      'url': url,
      'tickers': tickers,
      'categories': categories.map((item) => item.name).toList(),
      'topics': topics,
      'ticker_sentiments': tickerSentiments
          .map(
            (item) => {
              'ticker': item.ticker,
              'sentiment': item.sentiment.name,
              'label': item.label,
              'score': item.score,
            },
          )
          .toList(),
    };
  }

  static NewsSentiment _parseSentiment(String value) {
    final normalized = value.toLowerCase();
    if (normalized.contains('bullish')) return NewsSentiment.bullish;
    if (normalized.contains('bearish')) return NewsSentiment.bearish;
    if (normalized.contains('neutral')) return NewsSentiment.neutral;
    return NewsSentiment.unknown;
  }

  static NewsSentiment _parseSentimentFromCache(String? value) {
    switch ((value ?? '').toLowerCase()) {
      case 'bullish':
        return NewsSentiment.bullish;
      case 'bearish':
        return NewsSentiment.bearish;
      case 'neutral':
        return NewsSentiment.neutral;
      case 'unknown':
        return NewsSentiment.unknown;
      default:
        return NewsSentiment.unknown;
    }
  }

  static String _resolveAuthor(dynamic authorsRaw) {
    if (authorsRaw is String && authorsRaw.trim().isNotEmpty) {
      return authorsRaw.trim();
    }

    if (authorsRaw is List) {
      final first = authorsRaw
          .map((item) => item.toString().trim())
          .firstWhere((item) => item.isNotEmpty, orElse: () => '');
      if (first.isNotEmpty) return first;
    }

    return 'N/A';
  }

  static String? _asNonEmptyString(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }

  static DateTime _parsePublishedAt(String raw) {
    if (raw.length >= 15 && raw.contains('T')) {
      final year = int.tryParse(raw.substring(0, 4));
      final month = int.tryParse(raw.substring(4, 6));
      final day = int.tryParse(raw.substring(6, 8));
      final hour = int.tryParse(raw.substring(9, 11));
      final minute = int.tryParse(raw.substring(11, 13));
      final second = int.tryParse(raw.substring(13, 15));

      if (year != null &&
          month != null &&
          day != null &&
          hour != null &&
          minute != null &&
          second != null) {
        return DateTime(year, month, day, hour, minute, second);
      }
    }

    return DateTime.now();
  }

  static DateTime _parseIsoTime(String? raw) {
    if (raw == null || raw.isEmpty) return DateTime.now();
    return DateTime.tryParse(raw) ?? DateTime.now();
  }

  static List<NewsTickerSentiment> _parseTickerSentiments(
    dynamic raw,
    NewsSentiment articleSentiment,
  ) {
    if (raw is! List) return const [];

    return raw
        .whereType<Map>()
        .map((item) {
          final ticker = (item['ticker']?.toString() ?? '')
              .trim()
              .toUpperCase();
          if (ticker.isEmpty) return null;

          final labelRaw = (item['ticker_sentiment_label']?.toString() ?? '')
              .trim();
          final scoreRaw = (item['ticker_sentiment_score']?.toString() ?? '')
              .trim();
          final score = double.tryParse(scoreRaw);

          NewsSentiment sentiment;
          if (labelRaw.isNotEmpty) {
            sentiment = _parseSentiment(labelRaw);
          } else if (score != null) {
            if (score > 0) {
              sentiment = NewsSentiment.bullish;
            } else if (score < 0) {
              sentiment = NewsSentiment.bearish;
            } else {
              sentiment = NewsSentiment.neutral;
            }
          } else {
            sentiment = articleSentiment;
          }

          return NewsTickerSentiment(
            ticker: ticker,
            sentiment: sentiment,
            label: _sentimentLabel(sentiment),
            score: score,
          );
        })
        .whereType<NewsTickerSentiment>()
        .toList();
  }

  static List<NewsTickerSentiment> _parseTickerSentimentsFromCache(
    dynamic raw,
    NewsSentiment articleSentiment,
  ) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) {
          final ticker = (item['ticker']?.toString() ?? '')
              .trim()
              .toUpperCase();
          if (ticker.isEmpty) return null;

          final sentiment = _parseSentimentFromCache(
            item['sentiment'] as String?,
          );
          final resolvedSentiment = sentiment == NewsSentiment.unknown
              ? articleSentiment
              : sentiment;

          return NewsTickerSentiment(
            ticker: ticker,
            sentiment: resolvedSentiment,
            label: (item['label']?.toString() ?? '').trim().isEmpty
                ? _sentimentLabel(resolvedSentiment)
                : item['label'].toString().trim(),
            score: double.tryParse((item['score']?.toString() ?? '').trim()),
          );
        })
        .whereType<NewsTickerSentiment>()
        .toList();
  }

  static String _sentimentLabel(NewsSentiment sentiment) {
    switch (sentiment) {
      case NewsSentiment.bullish:
        return 'Bullish';
      case NewsSentiment.bearish:
        return 'Bearish';
      case NewsSentiment.neutral:
        return 'Neutral';
      case NewsSentiment.unknown:
        return 'Unknown';
    }
  }

  static List<String> _parseApiTopics(dynamic rawTopics) {
    if (rawTopics is! List) return const [];
    return rawTopics
        .whereType<Map>()
        .map((topicItem) => topicItem['topic']?.toString() ?? '')
        .map(NewsTopicMapper.normalizeTopic)
        .where((topic) => topic.isNotEmpty)
        .toSet()
        .toList();
  }

  static List<String> _parseCachedTopics(dynamic rawTopics) {
    if (rawTopics is! List) return const [];
    return rawTopics
        .map((item) => item.toString())
        .map(NewsTopicMapper.normalizeTopic)
        .where((topic) => topic.isNotEmpty)
        .toSet()
        .toList();
  }

  static Set<NewsCategory> _parseCachedCategories(dynamic rawCategories) {
    if (rawCategories is! List) return const {};
    return rawCategories
        .map((item) => item.toString().trim().toLowerCase())
        .map((raw) {
          switch (raw) {
            case 'sectors':
              return NewsCategory.sectors;
            case 'stocks':
              return NewsCategory.sectors;
            case 'economy':
              return NewsCategory.economy;
            default:
              return null;
          }
        })
        .whereType<NewsCategory>()
        .toSet();
  }
}
