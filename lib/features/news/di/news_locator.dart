import 'package:get_it/get_it.dart';
import 'package:mobile/features/news/data/datasources/news_local_data_source.dart';
import 'package:mobile/features/news/data/datasources/news_remote_datasource.dart';
import 'package:mobile/features/news/data/repositories/news_repository_impl.dart';
import 'package:mobile/features/news/domain/repositories/news_repository.dart';
import 'package:mobile/features/news/presentation/cubit/news_cubit.dart';

void setupNewsLocator(GetIt sl) {
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerFactory(() => NewsCubit(newsRepository: sl()));
}
