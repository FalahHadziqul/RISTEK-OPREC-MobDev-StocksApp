import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/constants/constant_routes.dart';
import 'package:mobile/features/stocks/domain/entities/stock_entity.dart';
import 'package:mobile/features/stocks/presentation/widgets/stock_tile.dart';

class StockSectionPayload {
  final String title;
  final List<StockEntity> stocks;

  const StockSectionPayload({
    required this.title,
    required this.stocks,
  });
}

class StockSectionScreen extends StatelessWidget {
  final String title;
  final List<StockEntity> stocks;

  const StockSectionScreen({
    super.key,
    required this.title,
    required this.stocks,
  });

  @override
  Widget build(BuildContext context) {
    if (stocks.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(
          child: Text('No stocks available for this section.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.98,
        ),
        itemCount: stocks.length,
        itemBuilder: (context, index) {
          final stock = stocks[index];
          return StockTile(
            stock: stock,
            compact: true,
            onTap: () => context.pushNamed(
              ConstantRoutes.stockDetail,
              pathParameters: {'symbol': stock.symbol},
            ),
          );
        },
      ),
    );
  }
}
