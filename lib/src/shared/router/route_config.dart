import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../modules/tasks/ui/pages/task_list_page.dart';
import '../../modules/tasks/ui/widgets/shell_bottom_navigation_bar.dart';
import 'routes.dart';

final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'appRouterKey');
final _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'appRouterKey');

abstract class RouteConfig {
  static GoRouter config = GoRouter(
    routes: routes,
    initialLocation: Routes.todos,
    navigatorKey: navigatorKey,
  );

  static List<RouteBase> get routes => [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) =>
              ShellBottomNavigationBar(child: child),
          routes: [
            GoRoute(
              path: Routes.todos,
              parentNavigatorKey: _shellNavigatorKey,
              pageBuilder: (context, state) => NoTransitionPage(
                child: TaskListPage.todo(),
              ),
            ),
            GoRoute(
              path: Routes.dones,
              parentNavigatorKey: _shellNavigatorKey,
              pageBuilder: (context, state) => NoTransitionPage(
                child: TaskListPage.done(),
              ),
            ),
            GoRoute(
              path: Routes.search,
              parentNavigatorKey: _shellNavigatorKey,
              pageBuilder: (context, state) => NoTransitionPage(
                child: TaskListPage.search(),
              ),
            ),
          ],
        ),
      ];
}
