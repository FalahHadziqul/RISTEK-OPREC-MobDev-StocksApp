import 'package:equatable/equatable.dart';

/// Domain entity representing the AlphaVantage OVERVIEW response.
class CompanyOverview extends Equatable {
  final String symbol;
  final String name;
  final String description;
  final String exchange;
  final String sector;
  final String industry;
  final String marketCap;
  final String peRatio;
  final String dividendYield;
  final String eps;
  final String high52Week;
  final String low52Week;

  const CompanyOverview({
    required this.symbol,
    required this.name,
    required this.description,
    required this.exchange,
    required this.sector,
    required this.industry,
    required this.marketCap,
    required this.peRatio,
    required this.dividendYield,
    required this.eps,
    required this.high52Week,
    required this.low52Week,
  });

  @override
  List<Object> get props => [
    symbol,
    name,
    description,
    exchange,
    sector,
    industry,
    marketCap,
    peRatio,
    dividendYield,
    eps,
    high52Week,
    low52Week,
  ];
}
