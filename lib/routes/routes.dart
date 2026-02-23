import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/constants/constant_routes.dart';
import 'package:mobile/routes/features/main_routes.dart';

GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

abstract class Routes {
  static final routerConfig = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: ConstantRoutes.stocks, 
    routes: [
      ...mainRoutes,
    ],
  );
}