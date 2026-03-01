import 'package:equatable/equatable.dart';

enum NewsSentiment { bullish, bearish, neutral, unknown }

enum NewsCategory { all, watchlist, crypto, forex, stocks, economy }

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
  ];
}
