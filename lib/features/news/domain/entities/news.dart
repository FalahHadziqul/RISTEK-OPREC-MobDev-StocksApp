import 'package:equatable/equatable.dart';

enum NewsSentiment { bullish, bearish, neutral, unknown }

enum NewsCategory { all, sectors, economy }

class NewsTickerSentiment extends Equatable {
  final String ticker;
  final NewsSentiment sentiment;
  final String label;
  final double? score;

  const NewsTickerSentiment({
    required this.ticker,
    required this.sentiment,
    required this.label,
    required this.score,
  });

  @override
  List<Object?> get props => [ticker, sentiment, label, score];
}

class NewsEntity extends Equatable {
  final String id;
  final String title;
  final String summary;
  final String? bannerImageUrl;
  final String author;
  final String source;
  final DateTime publishedAt;
  final NewsSentiment sentiment;
  final String url;
  final List<String> tickers;
  final List<NewsTickerSentiment> tickerSentiments;
  final Set<NewsCategory> categories;

  const NewsEntity({
    required this.id,
    required this.title,
    required this.summary,
    required this.bannerImageUrl,
    required this.author,
    required this.source,
    required this.publishedAt,
    required this.sentiment,
    required this.url,
    required this.tickers,
    required this.tickerSentiments,
    required this.categories,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    summary,
    bannerImageUrl,
    author,
    source,
    publishedAt,
    sentiment,
    url,
    tickers,
    tickerSentiments,
    categories,
  ];
}
