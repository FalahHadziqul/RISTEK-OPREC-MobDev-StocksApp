import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/features/stocks/data/datasources/stock_local_data_source.dart';
import 'package:mobile/features/stocks/data/datasources/stock_remote_data_source.dart';
import 'package:mobile/features/stocks/data/repositories/stock_repository_impl.dart';
import 'package:mobile/features/stocks/domain/repositories/stock_repository.dart';
import 'package:mobile/features/stocks/presentation/cubit/stock_cubit.dart';

final sl = GetIt.instance;

Future<void> setupAppLocator() async {
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton(() => http.Client());
  }

  if (!sl.isRegistered<StockRemoteDataSource>()) {
    sl.registerLazySingleton<StockRemoteDataSource>(
      () => StockRemoteDataSourceImpl(client: sl()),
    );
  }

  if (!sl.isRegistered<StockLocalDataSource>()) {
    sl.registerLazySingleton<StockLocalDataSource>(
      () => StockLocalDataSourceImpl(),
    );
  }

  if (!sl.isRegistered<StockRepository>()) {
    sl.registerLazySingleton<StockRepository>(
      () => StockRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
    );
  }

  if (!sl.isRegistered<StockCubit>()) {
    sl.registerFactory(() => StockCubit(stockRepository: sl()));
  }
}
