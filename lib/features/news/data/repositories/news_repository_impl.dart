import 'package:mobile/features/news/data/datasources/news_local_data_source.dart';
import 'package:mobile/features/news/data/datasources/news_remote_datasource.dart';
import 'package:mobile/features/news/domain/entities/news.dart';
import 'package:mobile/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<NewsEntity>> getNews() async {
    final cachedFresh = await localDataSource.getCachedNews();
    if (cachedFresh != null) {
      return cachedFresh;
    }

    try {
      final fresh = await remoteDataSource.fetchNewsSentiment();
      await localDataSource.cacheNews(fresh);
      return fresh;
    } catch (_) {
      final cachedStale = await localDataSource.getCachedNews(
        allowExpired: true,
      );
      if (cachedStale != null) {
        return cachedStale;
      }
      rethrow;
    }
  }

  @override
  Future<List<NewsEntity>?> getCachedNews({bool allowExpired = false}) {
    return localDataSource.getCachedNews(allowExpired: allowExpired);
  }

  @override
  Future<List<NewsEntity>> refreshNews({bool force = false}) async {
    if (force) {
      await localDataSource.invalidateNewsCache();
    }

    try {
      final fresh = await remoteDataSource.fetchNewsSentiment();
      await localDataSource.cacheNews(fresh);
      return fresh;
    } catch (_) {
      final cachedStale = await localDataSource.getCachedNews(
        allowExpired: true,
      );
      if (cachedStale != null) {
        return cachedStale;
      }
      rethrow;
    }
  }

  @override
  Future<void> invalidateNewsCache() {
    return localDataSource.invalidateNewsCache();
  }
}
