import '../entities/stock_entity.dart';

abstract class StockRepository {
  Future<List<StockEntity>> getTopGainers();
}