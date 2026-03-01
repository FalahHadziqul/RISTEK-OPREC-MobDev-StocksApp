import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/news/domain/entities/news.dart';
import 'package:mobile/features/news/domain/repositories/news_repository.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository newsRepository;

  NewsCubit({required this.newsRepository}) : super(NewsInitial());

  Future<void> loadNews({bool forceRefresh = false}) async {
    final cachedAny = await newsRepository.getCachedNews(allowExpired: true);

    if (cachedAny != null) {
      emit(
        NewsLoaded(
          feed: cachedAny,
          selectedCategory: NewsCategory.all,
          isRefreshing: true,
          isStaleData: true,
        ),
      );

      final cachedFresh = await newsRepository.getCachedNews();
      if (cachedFresh != null && !forceRefresh) {
        emit(
          NewsLoaded(
            feed: cachedFresh,
            selectedCategory: NewsCategory.all,
            isRefreshing: false,
            isStaleData: false,
          ),
        );
        return;
      }

      try {
        final fresh = await newsRepository.refreshNews(force: forceRefresh);
        emit(
          NewsLoaded(
            feed: fresh,
            selectedCategory: NewsCategory.all,
            isRefreshing: false,
            isStaleData: false,
          ),
        );
      } catch (_) {
        emit(
          NewsLoaded(
            feed: cachedAny,
            selectedCategory: _selectedCategoryOrDefault(),
            isRefreshing: false,
            isStaleData: true,
          ),
        );
      }
      return;
    }

    emit(NewsLoading());

    try {
      final fresh = await newsRepository.refreshNews(force: forceRefresh);
      emit(
        NewsLoaded(
          feed: fresh,
          selectedCategory: NewsCategory.all,
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
      emit(current.copyWith(selectedCategory: category));
    }
  }

  NewsCategory _selectedCategoryOrDefault() {
    final current = state;
    if (current is NewsLoaded) return current.selectedCategory;
    return NewsCategory.all;
  }
}
