import 'package:go_router/go_router.dart';
import 'package:mobile/core/constants/constant_routes.dart';
import 'package:mobile/features/stocks/presentation/pages/stocks_screen.dart';
import 'package:mobile/features/stocks/presentation/pages/stock_detail_screen.dart';
import 'package:mobile/routes/routes.dart'; // To access rootNavigatorKey

final StatefulShellBranch stocksBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: ConstantRoutes.stocks,
      path: ConstantRoutes.stocks,
      builder: (context, state) => const StocksScreen(),
      routes: [
        GoRoute(
          // Pushes the detail screen over the bottom nav bar
          parentNavigatorKey: rootNavigatorKey,
          name: ConstantRoutes.stockDetail,
          path: 'detail/:symbol', // e.g., /stocks/detail/IBM
          builder: (context, state) {
            final symbol = state.pathParameters['symbol'] ?? '';
            return StockDetailScreen(symbol: symbol);
          },
        ),
      ],
    ),
  ],
);
