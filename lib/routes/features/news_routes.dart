import 'package:go_router/go_router.dart';
import 'package:mobile/core/constants/constant_routes.dart';
import 'package:mobile/features/news/presentation/pages/news_screen.dart';

final StatefulShellBranch newsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: ConstantRoutes.news,
      path: ConstantRoutes.news,
      builder: (context, state) => const NewsScreen(),
    ),
  ],
);