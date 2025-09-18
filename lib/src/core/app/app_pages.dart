// lib/src/core/app/app_pages.dart
import 'package:go_router/go_router.dart';
import 'package:time_planner/src/features/planner/presentation/planner_screen.dart';
import 'app_routes.dart';
import 'package:time_planner/src/features/login/presentation/login_screen.dart';

class AppPages {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.planner,
        builder: (context, state) => const PlannerScreen(),
      ),
    ],
  );
}