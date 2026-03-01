import 'package:mobile/features/news/domain/entities/news.dart';

class NewsModel extends NewsEntity {
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
  });

  factory NewsModel.fromApiJson(Map<String, dynamic> json) {
    final rawTitle = (json['title'] as String? ?? '').trim();
    final rawTime = (json['time_published'] as String? ?? '').trim();
    final rawUrl = (json['url'] as String? ?? '').trim();

    final title = rawTitle.isEmpty ? 'Untitled News' : rawTitle;
    final publishedAt = _parsePublishedAt(rawTime);
    final url = rawUrl;
    final id = url.isNotEmpty ? url : '$title|$rawTime';

    return NewsModel(
      id: id,
      title: title,
      summary: (json['summary'] as String? ?? '').trim(),
      bannerImageUrl: _asNonEmptyString(json['banner_image']),
      author: _resolveAuthor(json['authors']),
      source: _asNonEmptyString(json['source']) ?? 'Unknown',
      publishedAt: publishedAt,
      sentiment: _parseSentiment(
        (json['overall_sentiment_label'] as String? ?? '').trim(),
      ),
      url: url,
      tickers: _parseTickers(json['ticker_sentiment']),
    );
  }

  factory NewsModel.fromCacheJson(Map<String, dynamic> json) {
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
      sentiment: _parseSentimentFromCache(json['sentiment'] as String?),
      url: (json['url'] as String? ?? '').trim(),
      tickers: (json['tickers'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList(),
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

  static List<String> _parseTickers(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map((item) {
          if (item is Map<String, dynamic>) {
            return (item['ticker'] as String? ?? '').trim().toUpperCase();
          }
          if (item is Map) {
            return (item['ticker']?.toString() ?? '').trim().toUpperCase();
          }
          return '';
        })
        .where((ticker) => ticker.isNotEmpty)
        .toSet()
        .toList();
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
}
