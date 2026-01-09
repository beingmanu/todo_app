import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_withbloc/src/config/router/routes.dart';
import 'package:todo_withbloc/src/domain/model/todo_model.dart';
import 'package:todo_withbloc/src/presentation/bloc/todo/todo_bloc.dart';
import 'package:todo_withbloc/src/presentation/bloc/todo/todo_event.dart';
import 'package:todo_withbloc/src/presentation/bloc/todo/todo_state.dart';

import '../../utils/constants/colors.dart';

class ToDoScreen extends HookWidget {
  final String? existingTodo;
  const ToDoScreen({super.key, this.existingTodo});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final TextEditingController taskController = useTextEditingController();
    TodoData? todo;

    useEffect(() {
      final currentState = context.read<TodoBloc>().state;

      if (existingTodo != null && existingTodo != "A") {
        try {
          final index = int.parse(existingTodo!);

          if (index >= 0 && index < currentState.todos.length) {
            todo = currentState.todos[index];

            taskController.text = todo!.text;

            context.read<TodoBloc>().add(CheckCategories(todo!.category));
          }
        } catch (e) {
          debugPrint("Error parsing index: $e");
        }
      }

      return null;
    }, []);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => context.go(AppRoutes.home),
      child: Scaffold(
        appBar: AppBar(
          title: Text("ToDo"),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: PrimaryColors.k100,
        bottomNavigationBar: BlocConsumer<TodoBloc, TodoState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PrimaryColors.k600,
                  fixedSize: Size(size.width * .8, 40),
                ),
                onPressed: () {
                  if (existingTodo != null && existingTodo != "0") {
                    context.read<TodoBloc>().add(
                      AddTodo(
                        task: taskController.text,
                        category: state.category!,
                      ),
                    );
                  } else {
                    context.read<TodoBloc>().add(
                      UpdateTodo(
                        category: state.category!,
                        id: state.todos[int.parse(existingTodo ?? "0")].id,
                        task: taskController.text,
                      ),
                    );
                  }
                },
                child: state.isLoading
                    ? CircularProgressIndicator(color: PrimaryColors.k100)
                    : Text("Save", style: TextStyle(color: PrimaryColors.k100)),
              ),
            );
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  surfaceTintColor: Colors.transparent,
                  color: PrimaryColors.k400,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: taskController,
                      maxLines: null,
                      // 2. Sets the keyboard to a type that supports multi-line
                      keyboardType: TextInputType.multiline,
                      // 3. Changes the "Done" button to a "Return/New Line" icon
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Wrap(
                  children: [
                    CategoryWidget(category: TodoCategories.personal),
                    CategoryWidget(category: TodoCategories.shopping),
                    CategoryWidget(category: TodoCategories.work),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryWidget extends HookWidget {
  final TodoCategories category;
  const CategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<TodoBloc>().add(CheckCategories(category));
          },
          child: Card(
            surfaceTintColor: Colors.transparent,
            color: state.category == category
                ? PrimaryColors.k600
                : PrimaryColors.k200,

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                category.value,
                style: TextStyle(
                  color: state.category == category
                      ? PrimaryColors.k50
                      : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
