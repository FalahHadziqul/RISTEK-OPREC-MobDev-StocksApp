import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/di/injection.dart';
import 'package:mobile/core/themes/color_theme.dart';
import 'package:mobile/features/stocks/domain/entities/stock_entity.dart';
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
          title: Text(
            "RiSTOCK",
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
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
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionHeader(title: 'Popular', theme: theme),
                  const SizedBox(height: 8),
                  ...state.mostActivelyTraded.map(
                    (stock) => _StockTile(stock: stock, theme: theme),
                  ),
                  const SizedBox(height: 28),
                  _SectionHeader(title: 'Top Gainers Today', theme: theme),
                  const SizedBox(height: 8),
                  ...state.topGainers.map(
                    (stock) => _StockTile(stock: stock, theme: theme),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

class _StockTile extends StatelessWidget {
  final StockEntity stock;
  final ThemeData theme;

  const _StockTile({required this.stock, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isPositive = !stock.changePercentage.startsWith('-');
    final palette = PColor();
    final colorScheme = theme.colorScheme;
    final borderColor = colorScheme.outlineVariant.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.78 : 0.92,
    );
    final shadowColor = colorScheme.shadow.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.10 : 0.08,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => context.push('/detail/${stock.symbol}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            border: Border.all(color: borderColor, width: 0.9),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stock.symbol,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$${stock.price}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    stock.changePercentage,
                    style: TextStyle(
                      color: isPositive ? palette.success : palette.danger,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
