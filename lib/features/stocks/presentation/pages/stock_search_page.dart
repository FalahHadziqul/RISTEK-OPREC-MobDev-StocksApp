import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/constants/constant_routes.dart';
import 'package:mobile/core/themes/color_theme.dart';
import 'package:mobile/features/stocks/domain/entities/stock_entity.dart';
import 'package:mobile/features/stocks/presentation/widgets/stock_tile.dart';

class StockSearchPayload {
  final List<StockEntity> stocks;

  const StockSearchPayload({required this.stocks});
}

class StockSearchPage extends StatefulWidget {
  final List<StockEntity> stocks;

  const StockSearchPage({super.key, required this.stocks});

  @override
  State<StockSearchPage> createState() => _StockSearchPageState();
}

class _StockSearchPageState extends State<StockSearchPage> {
  late final TextEditingController _controller;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<StockEntity> get _filteredStocks {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.stocks;

    return widget.stocks.where((stock) {
      return stock.symbol.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = PColor();
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? color.textPrimaryDark : color.textPrimaryLight;
    final filtered = _filteredStocks;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Stocks',
          style: theme.textTheme.titleLarge?.copyWith(color: textColor),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search ticker...',
                prefixIcon: Icon(Icons.search, color: textColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const _EmptySearchState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final stock = filtered[index];
                      return StockTile(
                        stock: stock,
                        onTap: () => context.pushNamed(
                          ConstantRoutes.stockDetail,
                          pathParameters: {'symbol': stock.symbol},
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          'No stocks found.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
