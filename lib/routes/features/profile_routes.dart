import 'package:go_router/go_router.dart';
import 'package:mobile/core/constants/constant_routes.dart';
import 'package:mobile/features/profile/presentation/pages/profile_screen.dart';

final StatefulShellBranch profileBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: ConstantRoutes.profile,
      path: ConstantRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);