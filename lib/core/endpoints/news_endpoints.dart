class NewsEndpoints {
  static const String _baseUrl = 'https://www.alphavantage.co/query';

  static Uri newsSentiment({required String apiKey, int limit = 50}) {
    return Uri.parse(
      '$_baseUrl?function=NEWS_SENTIMENT&sort=LATEST&limit=$limit&apikey=$apiKey',
    );
  }
}
