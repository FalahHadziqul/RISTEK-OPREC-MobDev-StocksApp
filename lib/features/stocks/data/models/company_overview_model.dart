import '../../domain/entities/company_overview.dart';

class CompanyOverviewModel extends CompanyOverview {
  const CompanyOverviewModel({
    required super.symbol,
    required super.name,
    required super.description,
    required super.exchange,
    required super.sector,
    required super.industry,
    required super.marketCap,
    required super.peRatio,
    required super.dividendYield,
    required super.eps,
    required super.high52Week,
    required super.low52Week,
  });

  /// Parse the AlphaVantage OVERVIEW JSON response.
  factory CompanyOverviewModel.fromJson(Map<String, dynamic> json) {
    return CompanyOverviewModel(
      symbol: json['Symbol'] ?? '',
      name: json['Name'] ?? '',
      description: json['Description'] ?? '',
      exchange: json['Exchange'] ?? '',
      sector: json['Sector'] ?? '',
      industry: json['Industry'] ?? '',
      marketCap: json['MarketCapitalization'] ?? '0',
      peRatio: json['PERatio'] ?? 'N/A',
      dividendYield: json['DividendYield'] ?? '0',
      eps: json['EPS'] ?? 'N/A',
      high52Week: json['52WeekHigh'] ?? 'N/A',
      low52Week: json['52WeekLow'] ?? 'N/A',
    );
  }

  /// Serialize to JSON for Hive caching.
  Map<String, dynamic> toJson() {
    return {
      'Symbol': symbol,
      'Name': name,
      'Description': description,
      'Exchange': exchange,
      'Sector': sector,
      'Industry': industry,
      'MarketCapitalization': marketCap,
      'PERatio': peRatio,
      'DividendYield': dividendYield,
      'EPS': eps,
      '52WeekHigh': high52Week,
      '52WeekLow': low52Week,
    };
  }
}
