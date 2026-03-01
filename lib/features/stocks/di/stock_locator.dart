import 'package:get_it/get_it.dart';
import 'package:mobile/features/stocks/data/datasources/stock_local_data_source.dart';
import 'package:mobile/features/stocks/data/datasources/stock_remote_data_source.dart';
import 'package:mobile/features/stocks/data/repositories/stock_repository_impl.dart';
import 'package:mobile/features/stocks/domain/repositories/stock_repository.dart';
import 'package:mobile/features/stocks/presentation/cubit/stock_cubit.dart';
import 'package:mobile/features/stocks/presentation/cubit/stock_detail_cubit.dart';

/// Registers all Stock-feature dependencies.
///
/// Depends on [http.Client] from core locator.
void setupStockLocator(GetIt sl) {
  // ── Data sources ──────────────────────────────────────────────────────
  sl.registerLazySingleton<StockRemoteDataSource>(
    () => StockRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<StockLocalDataSource>(
    () => StockLocalDataSourceImpl(),
  );

  // ── Repositories ──────────────────────────────────────────────────────
  sl.registerLazySingleton<StockRepository>(
    () => StockRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // ── Cubits ────────────────────────────────────────────────────────────
  // Factory: new instance per screen / BlocProvider.
  sl.registerFactory(() => StockCubit(stockRepository: sl()));
  sl.registerFactory(() => StockDetailCubit(stockRepository: sl()));
}
