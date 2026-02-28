class StockEndpoints {
  static const String _baseUrl = 'https://www.alphavantage.co/query';

  static Uri topGainers({required String apiKey}) {
    return Uri.parse('$_baseUrl?function=TOP_GAINERS_LOSERS&apikey=$apiKey');
  }
}
