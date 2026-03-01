import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/constants/constant_routes.dart';
import 'package:mobile/core/di/injection.dart';
import 'package:mobile/core/themes/color_theme.dart';
import 'package:mobile/features/stocks/domain/entities/stock_entity.dart';
import 'package:mobile/features/stocks/presentation/pages/stock_search_page.dart';
import 'package:mobile/features/stocks/presentation/pages/stock_section_screen.dart';
import 'package:mobile/features/stocks/presentation/widgets/stock_tile.dart';
import 'package:mobile/utils/theme_manager.dart';
import '../cubit/stock_cubit.dart';

class StocksScreen extends StatelessWidget {
  const StocksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final color = PColor();

    return BlocProvider(
      create: (context) => sl<StockCubit>()..loadMarketMovers(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("RiSTOCK"),
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
        body: BlocBuilder<StockCubit, StockState>(
          builder: (context, state) {
            if (state is StockLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StockError) {
              return Center(
                child: Text(
                  state.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              );
            } else if (state is StockLoaded) {
              final popularStocks = state.mostActivelyTraded.take(10).toList();
              final topGainers = state.topGainers.take(10).toList();
              final isEmptyFeedWithoutData =
                  state.mostActivelyTraded.isEmpty &&
                  state.topGainers.isEmpty &&
                  !state.isRefreshing;
              final allSearchableStocks = _aggregateSearchStocks(
                mostActivelyTraded: state.mostActivelyTraded,
                topGainers: state.topGainers,
              );

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SearchTrigger(
                    onTap: () => context.pushNamed(
                      ConstantRoutes.stockSearch,
                      extra: StockSearchPayload(stocks: allSearchableStocks),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionHeader(
                    title: 'Popular',
                    onSeeAll: () => context.pushNamed(
                      ConstantRoutes.stockSection,
                      pathParameters: const {'sectionKey': 'popular'},
                      extra: StockSectionPayload(
                        title: 'Popular',
                        stocks: state.mostActivelyTraded,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (popularStocks.isEmpty &&
                      (state.isApiLimitHit == true || isEmptyFeedWithoutData))
                    _NoStocksFoundText(theme: theme)
                  else
                    ...popularStocks.map(
                      (stock) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: StockTile(
                          stock: stock,
                          onTap: () => context.pushNamed(
                            ConstantRoutes.stockDetail,
                            pathParameters: {'symbol': stock.symbol},
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 28),
                  _SectionHeader(
                    title: 'Top Gainers Today',
                    onSeeAll: () => context.pushNamed(
                      ConstantRoutes.stockSection,
                      pathParameters: const {'sectionKey': 'top-gainers'},
                      extra: StockSectionPayload(
                        title: 'Top Gainers Today',
                        stocks: state.topGainers,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (topGainers.isEmpty &&
                      (state.isApiLimitHit == true || isEmptyFeedWithoutData))
                    _NoStocksFoundText(theme: theme)
                  else
                    ...topGainers.map(
                      (stock) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: StockTile(
                          stock: stock,
                          onTap: () => context.pushNamed(
                            ConstantRoutes.stockDetail,
                            pathParameters: {'symbol': stock.symbol},
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }
            return const Center(child: Text("Welcome to Stocks"));
          },
        ),
      ),
    );
  }
}

class _NoStocksFoundText extends StatelessWidget {
  final ThemeData theme;

  const _NoStocksFoundText({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        'No Stocks Found',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

List<StockEntity> _aggregateSearchStocks({
  required List<StockEntity> mostActivelyTraded,
  required List<StockEntity> topGainers,
}) {
  final uniqueBySymbol = <String, StockEntity>{};
  for (final stock in [...mostActivelyTraded, ...topGainers]) {
    uniqueBySymbol[stock.symbol.toUpperCase()] = stock;
  }
  return uniqueBySymbol.values.toList();
}

class _SearchTrigger extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchTrigger({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = PColor();
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? color.textPrimaryDark : color.textPrimaryLight;
    return SearchBar(
      hintText: 'Search ticker or company...',
      leading: Icon(Icons.search, color: textColor),
      textStyle: WidgetStatePropertyAll(
        theme.textTheme.titleMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: WidgetStatePropertyAll(
        theme.colorScheme.surfaceContainer,
      ),
      elevation: const WidgetStatePropertyAll(0),
      side: WidgetStatePropertyAll(
        BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      onTap: onTap,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = PColor();
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? color.textPrimaryDark : color.textPrimaryLight;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(foregroundColor: textColor),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('See All', style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
