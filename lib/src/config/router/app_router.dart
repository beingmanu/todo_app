import 'package:go_router/go_router.dart';
import 'package:todo_withbloc/main.dart';
import 'package:todo_withbloc/src/config/router/routes.dart';
import 'package:todo_withbloc/src/presentation/view/cswipe_screen.dart';
import 'package:todo_withbloc/src/presentation/view/home_screen.dart';
import 'package:todo_withbloc/src/presentation/view/login_screen.dart';
import 'package:todo_withbloc/src/presentation/view/profile_screen.dart';
import 'package:todo_withbloc/src/presentation/view/todo_screen.dart';

import '../../presentation/view/audio_player_screen.dart';

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(path: AppRoutes.home, builder: (context, state) => HomeScreen()),
    GoRoute(path: AppRoutes.login, builder: (context, state) => LoginScreen()),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.cSwipe,
      builder: (context, state) => CardSwipeScreen(),
    ),
    GoRoute(
      path: AppRoutes.todo,
      builder: (context, state) =>
          ToDoScreen(existingTodo: state.pathParameters['id']),
    ),
    GoRoute(
      path: AppRoutes.aPlayer,
      builder: (context, state) => AudioPlayerScreen(),
    ),
  ],
);
