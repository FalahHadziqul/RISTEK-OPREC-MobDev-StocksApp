class StockEntity {
  final String symbol;
  final String price;
  final String changePercentage;

  const StockEntity({
    required this.symbol,
    required this.price,
    required this.changePercentage,
  });
}