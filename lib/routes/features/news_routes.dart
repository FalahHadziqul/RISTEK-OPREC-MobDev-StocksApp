import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/constants/constant_routes.dart';
import 'package:mobile/features/news/domain/entities/news.dart';
import 'package:mobile/features/news/presentation/pages/news_detail_screen.dart';
import 'package:mobile/features/news/presentation/pages/news_screen.dart';

final StatefulShellBranch newsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: ConstantRoutes.news,
      path: ConstantRoutes.news,
      builder: (context, state) => const NewsScreen(),
    ),
    GoRoute(
      name: ConstantRoutes.newsDetail,
      path: '/news-detail',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! NewsEntity) {
          return const _NewsDetailFallbackScreen();
        }
        return NewsDetailScreen(article: extra);
      },
    ),
  ],
);

class _NewsDetailFallbackScreen extends StatelessWidget {
  const _NewsDetailFallbackScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Detail')),
      body: const Center(child: Text('News detail data is unavailable.')),
    );
  }
}
