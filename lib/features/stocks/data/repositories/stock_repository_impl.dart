import '../../domain/entities/stock_entity.dart';
import '../../domain/repositories/stock_repository.dart';
import '../datasources/stock_remote_data_source.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDataSource remoteDataSource;

  StockRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<StockEntity>> getTopGainers() async {
    try {
      final stockModels = await remoteDataSource.fetchTopGainers();
      return stockModels; // StockModel is a subclass of StockEntity, so this works!
    } catch (e) {
      // TODO
      rethrow; 
    }
  }
}