import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/constants/constant_routes.dart';
import 'package:mobile/features/stocks/presentation/pages/stock_detail_screen.dart';
import 'package:mobile/features/stocks/presentation/pages/stock_search_page.dart';
import 'package:mobile/features/stocks/presentation/pages/stock_section_screen.dart';
import 'package:mobile/features/stocks/presentation/pages/stocks_screen.dart';
import 'package:mobile/routes/routes.dart'; // To access rootNavigatorKey

final StatefulShellBranch stocksBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: ConstantRoutes.stocks,
      path: ConstantRoutes.stocks,
      builder: (context, state) => const StocksScreen(),
      routes: [
        GoRoute(
          name: ConstantRoutes.stockSearch,
          path: 'search',
          pageBuilder: (context, state) {
            final payload = state.extra as StockSearchPayload?;
            return CustomTransitionPage(
              key: state.pageKey,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    final curved = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    );
                    return FadeTransition(
                      opacity: curved,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.04),
                          end: Offset.zero,
                        ).animate(curved),
                        child: child,
                      ),
                    );
                  },
              child: StockSearchPage(
                stocks: payload?.stocks ?? const [],
              ),
            );
          },
        ),
        GoRoute(
          name: ConstantRoutes.stockSection,
          path: 'section/:sectionKey',
          builder: (context, state) {
            final payload = state.extra as StockSectionPayload?;
            final sectionKey = state.pathParameters['sectionKey'] ?? '';

            return StockSectionScreen(
              title: payload?.title ?? _defaultSectionTitle(sectionKey),
              stocks: payload?.stocks ?? const [],
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          name: ConstantRoutes.stockDetail,
          path: 'detail/:symbol',
          builder: (context, state) {
            final symbol = state.pathParameters['symbol'] ?? '';
            return StockDetailScreen(symbol: symbol);
          },
        ),
      ],
    ),
  ],
);

String _defaultSectionTitle(String sectionKey) {
  switch (sectionKey) {
    case 'popular':
      return 'Popular';
    case 'top-gainers':
      return 'Top Gainers Today';
    default:
      return 'Stocks';
  }
}
