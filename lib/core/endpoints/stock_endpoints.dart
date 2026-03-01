class StockEndpoints {
  static const String _baseUrl = 'https://www.alphavantage.co/query';

  static Uri topGainers({required String apiKey}) {
    return Uri.parse('$_baseUrl?function=TOP_GAINERS_LOSERS&apikey=$apiKey');
  }

  static Uri companyOverview({required String symbol, required String apiKey}) {
    return Uri.parse(
      '$_baseUrl?function=OVERVIEW&symbol=$symbol&apikey=$apiKey',
    );
  }

  static Uri dailyTimeSeries({required String symbol, required String apiKey}) {
    return Uri.parse(
      '$_baseUrl?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=$apiKey',
    );
  }
}
