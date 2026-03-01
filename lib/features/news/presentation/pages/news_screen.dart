import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/constants/constant_routes.dart';
import 'package:mobile/core/di/injection.dart';
import 'package:mobile/core/themes/color_theme.dart';
import 'package:mobile/features/news/domain/entities/news.dart';
import 'package:mobile/features/news/presentation/cubit/news_cubit.dart';
import 'package:mobile/features/news/presentation/widgets/news_card.dart';
import 'package:mobile/features/news/presentation/widgets/news_filter_chips.dart';
import 'package:mobile/utils/theme_manager.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final color = PColor();

    return BlocProvider(
      create: (_) => sl<NewsCubit>()..loadNews(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Market News'),
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: color.primary,
              ),
              tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              onPressed: () => ThemeManager().toggleTheme(),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 4),
            BlocSelector<NewsCubit, NewsState, NewsCategory>(
              selector: (state) {
                if (state is NewsLoaded) {
                  return state.selectedCategory;
                }
                return NewsCategory.all;
              },
              builder: (context, selectedCategory) {
                return NewsFilterChips(
                  selectedCategory: selectedCategory,
                  onSelected: (category) {
                    context.read<NewsCubit>().selectCategory(category);
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<NewsCubit, NewsState>(
                buildWhen: (previous, current) {
                  if (previous.runtimeType != current.runtimeType) return true;

                  if (previous is NewsLoaded && current is NewsLoaded) {
                    return previous.feed != current.feed ||
                        previous.selectedCategory != current.selectedCategory ||
                        previous.isRefreshing != current.isRefreshing ||
                        previous.isStaleData != current.isStaleData;
                  }

                  if (previous is NewsError && current is NewsError) {
                    return previous.message != current.message;
                  }

                  return false;
                },
                builder: (context, state) {
                  if (state is NewsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is NewsError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is NewsLoaded) {
                    if (state.feed.isEmpty) {
                      return Center(
                        child: Text(
                          'No news available right now.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => context.read<NewsCubit>().refreshNews(),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.feed.length,
                        itemBuilder: (context, index) {
                          final article = state.feed[index];
                          return NewsCard(
                            article: article,
                            onTap: () => context.pushNamed(
                              ConstantRoutes.newsDetail,
                              extra: article,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          height: 18,
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
