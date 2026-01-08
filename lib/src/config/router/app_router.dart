import 'package:go_router/go_router.dart';
import 'package:todo_withbloc/main.dart';
import 'package:todo_withbloc/src/config/router/routes.dart';
import 'package:todo_withbloc/src/presentation/view/home_screen.dart';
import 'package:todo_withbloc/src/presentation/view/login_screen.dart';
import 'package:todo_withbloc/src/presentation/view/todo_screen.dart';

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(path: AppRoutes.home, builder: (context, state) => HomeScreen()),
    GoRoute(path: AppRoutes.login, builder: (context, state) => LoginScreen()),
    GoRoute(
      path: AppRoutes.todo,
      builder: (context, state) =>
          ToDoScreen(existingTodo: state.pathParameters['id']),
    ),
  ],
);
