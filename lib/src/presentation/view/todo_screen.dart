import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_withbloc/src/config/router/routes.dart';

class ToDoScreen extends HookWidget {
  final String? existingTodo;
  const ToDoScreen({super.key, this.existingTodo});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => context.go(AppRoutes.home),
      child: Scaffold(appBar: AppBar(title: Text("ToDo $existingTodo"))),
    );
  }
}
