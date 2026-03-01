part of 'news_cubit.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsEntity> feed;
  final NewsCategory selectedCategory;
  final bool isRefreshing;
  final bool isStaleData;

  const NewsLoaded({
    required this.feed,
    this.selectedCategory = NewsCategory.all,
    this.isRefreshing = false,
    this.isStaleData = false,
  });

  NewsLoaded copyWith({
    List<NewsEntity>? feed,
    NewsCategory? selectedCategory,
    bool? isRefreshing,
    bool? isStaleData,
  }) {
    return NewsLoaded(
      feed: feed ?? this.feed,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isStaleData: isStaleData ?? this.isStaleData,
    );
  }

  @override
  List<Object?> get props => [
    feed,
    selectedCategory,
    isRefreshing,
    isStaleData,
  ];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}
