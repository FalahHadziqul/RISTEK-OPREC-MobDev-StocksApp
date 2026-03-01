import 'package:equatable/equatable.dart';
import 'company_overview.dart';
import 'price_series.dart';

/// Composite entity combining company info and price history.
class StockDetail extends Equatable {
  final CompanyOverview overview;
  final PriceSeries priceSeries;

  const StockDetail({required this.overview, required this.priceSeries});

  @override
  List<Object> get props => [overview, priceSeries];
}
