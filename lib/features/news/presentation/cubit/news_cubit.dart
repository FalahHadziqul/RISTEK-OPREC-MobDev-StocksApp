import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/news/domain/entities/news.dart';
import 'package:mobile/features/news/domain/repositories/news_repository.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository newsRepository;
  List<NewsEntity> _allNews = const [];

  NewsCubit({required this.newsRepository}) : super(NewsInitial());

  Future<void> loadNews({bool forceRefresh = false}) async {
    final selectedCategory = _selectedCategoryOrDefault();
    final cachedAny = await newsRepository.getCachedNews(allowExpired: true);

    if (cachedAny != null) {
      _allNews = cachedAny;
      emit(
        NewsLoaded(
          feed: _applyCategoryFilter(selectedCategory, cachedAny),
          selectedCategory: selectedCategory,
          isRefreshing: true,
          isStaleData: true,
        ),
      );

      final cachedFresh = await newsRepository.getCachedNews();
      List<NewsEntity> baselineFeed = cachedAny;
      if (cachedFresh != null && !forceRefresh) {
        _allNews = cachedFresh;
        baselineFeed = cachedFresh;
        emit(
          NewsLoaded(
            feed: _applyCategoryFilter(selectedCategory, cachedFresh),
            selectedCategory: selectedCategory,
            isRefreshing: true,
            isStaleData: false,
          ),
        );
      }

      try {
        final fresh = await newsRepository.refreshNews(force: forceRefresh);
        _allNews = fresh;
        emit(
          NewsLoaded(
            feed: _applyCategoryFilter(selectedCategory, fresh),
            selectedCategory: selectedCategory,
            isRefreshing: false,
            isStaleData: false,
          ),
        );
      } catch (_) {
        emit(
          NewsLoaded(
            feed: _applyCategoryFilter(selectedCategory, baselineFeed),
            selectedCategory: selectedCategory,
            isRefreshing: false,
            isStaleData: cachedFresh == null,
          ),
        );
      }
      return;
    }

    emit(NewsLoading());

    try {
      final fresh = await newsRepository.refreshNews(force: forceRefresh);
      _allNews = fresh;
      emit(
        NewsLoaded(
          feed: _applyCategoryFilter(selectedCategory, fresh),
          selectedCategory: selectedCategory,
          isRefreshing: false,
          isStaleData: false,
        ),
      );
    } catch (e) {
      emit(NewsError('Failed to fetch market news: ${e.toString()}'));
    }
  }

  Future<void> refreshNews() async {
    await loadNews(forceRefresh: true);
  }

  void selectCategory(NewsCategory category) {
    final current = state;
    if (current is NewsLoaded) {
      emit(
        current.copyWith(
          selectedCategory: category,
          feed: _applyCategoryFilter(category, _allNews),
        ),
      );
    }
  }

  List<NewsEntity> _applyCategoryFilter(
    NewsCategory category,
    List<NewsEntity> source,
  ) {
    if (category == NewsCategory.all) return List<NewsEntity>.from(source);
    return source
        .where((article) => article.categories.contains(category))
        .toList();
  }

  NewsCategory _selectedCategoryOrDefault() {
    final current = state;
    if (current is NewsLoaded) return current.selectedCategory;
    return NewsCategory.all;
  }
}
