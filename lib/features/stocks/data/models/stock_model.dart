import '../../domain/entities/stock_entity.dart';

class StockModel extends StockEntity {
  const StockModel({
    required super.symbol,
    required super.price,
    required super.changePercentage,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['ticker'] ?? 'Unknown',
      price: json['price'] ?? '0.0',
      changePercentage: json['change_percentage'] ?? '0.0%',
    );
  }
}