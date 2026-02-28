import 'package:get_it/get_it.dart';
import 'package:mobile/features/stocks/data/datasources/stock_remote_data_source.dart';
import 'package:mobile/features/stocks/data/repositories/stock_repository_impl.dart';
import 'package:mobile/features/stocks/domain/repositories/stock_repository.dart';
import 'package:mobile/features/stocks/presentation/cubit/stock_cubit.dart';

/// Registers all Stock-feature dependencies.
///
/// Depends on [http.Client] from core locator.
void setupStockLocator(GetIt sl) {
  // ── Data sources ──────────────────────────────────────────────────────
  sl.registerLazySingleton<StockRemoteDataSource>(
    () => StockRemoteDataSourceImpl(client: sl()),
  );

  // ── Repositories ──────────────────────────────────────────────────────
  sl.registerLazySingleton<StockRepository>(
    () => StockRepositoryImpl(remoteDataSource: sl()),
  );

  // ── Cubits ────────────────────────────────────────────────────────────
  // Factory: new instance per screen / BlocProvider.
  sl.registerFactory(() => StockCubit(stockRepository: sl()));
}
