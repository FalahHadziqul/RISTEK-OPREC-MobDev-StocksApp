import 'package:go_router/go_router.dart';
import 'package:mobile/features/main/presentation/pages/main_screen.dart';
import 'package:mobile/routes/features/news_routes.dart';
import 'package:mobile/routes/features/profile_routes.dart';
import 'package:mobile/routes/features/stocks_routes.dart';

List<RouteBase> mainRoutes = [
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) =>
        MainScreen(navigationShell: navigationShell),
    branches: [
      stocksBranch,
      newsBranch,
      profileBranch,
    ],
  ),
];