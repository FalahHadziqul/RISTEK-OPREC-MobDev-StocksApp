import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/di/injection.dart';
import 'package:mobile/core/themes/color_theme.dart';
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
      // Inject the Cubit using the locator (sl)
      create: (context) => sl<StockCubit>()..loadTopGainers(),
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
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.stocks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final stock = state.stocks[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          stock.symbol,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "\$${stock.price}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              stock.changePercentage,
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const Center(child: Text("Welcome to Stocks"));
          },
        ),
      ),
    );
  }
}
