import '../entities/news.dart';

abstract class NewsRepository {
  Future<List<NewsEntity>> getNews();
  Future<List<NewsEntity>?> getCachedNews({bool allowExpired = false});
  Future<List<NewsEntity>> refreshNews({bool force = false});
  Future<void> invalidateNewsCache();
}
