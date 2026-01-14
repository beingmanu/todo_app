import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:toastification/toastification.dart';
import 'package:todo_withbloc/src/config/router/app_router.dart';
import 'package:todo_withbloc/src/config/theme/app_themes.dart';
import 'package:todo_withbloc/src/presentation/bloc/cswipe/cswipe_bloc.dart';
import 'package:todo_withbloc/src/presentation/bloc/login/login_bloc.dart';
import 'package:todo_withbloc/src/presentation/bloc/todo/todo_bloc.dart';
import 'package:todo_withbloc/src/presentation/bloc/todo/todo_event.dart';

import 'src/service/floor.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();
  runApp(MainApp(todoDao: database.todoDao));
}

class MainApp extends StatefulWidget {
  final TodoDao todoDao;
  const MainApp({super.key, required this.todoDao});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LoginBloc()),
          BlocProvider(create: (_) => CswipeBloc()),
          BlocProvider(
            create: (_) => TodoBloc(widget.todoDao)..add(LoadTodos()),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          themeMode: ThemeMode.light,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
        ),
      ),
    );
  }
}
