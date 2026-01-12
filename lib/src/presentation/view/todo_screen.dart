import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_withbloc/src/config/router/routes.dart';
import 'package:todo_withbloc/src/config/theme/app_themes.dart';
import 'package:todo_withbloc/src/domain/model/todo_model.dart';
import 'package:todo_withbloc/src/presentation/bloc/todo/todo_bloc.dart';
import 'package:todo_withbloc/src/presentation/bloc/todo/todo_event.dart';
import 'package:todo_withbloc/src/presentation/bloc/todo/todo_state.dart';
import 'package:todo_withbloc/src/presentation/widgets/add_todo_widget.dart';
import 'package:todo_withbloc/src/presentation/widgets/filter_chips.dart';

import '../../utils/constants/colors.dart';
import '../../utils/toast_util.dart';

class ToDoScreen extends HookWidget {
  final String? existingTodo;
  const ToDoScreen({super.key, this.existingTodo});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final TextEditingController taskController = useTextEditingController();

    useEffect(() {
      TodoData? todo;

      final currentState = context.read<TodoBloc>().state;

      if (existingTodo != null && existingTodo != "New") {
        try {
          final index = int.parse(existingTodo!);

          if (index >= 0 && index < currentState.todos.length) {
            todo = currentState.todos[index];

            taskController.text = todo.text;

            context.read<TodoBloc>().add(CheckCategories(todo.category));
          }
        } catch (e) {
          debugPrint("Error parsing index: $e");
        }
      } else {
        context.read<TodoBloc>().add(CheckCategories(TodoCategories.personal));
      }

      return null;
    }, []);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => context.go(AppRoutes.home),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "New Tasks",
            style: AppTheme.darkTheme.textTheme.displayLarge,
          ),
        ),

        bottomNavigationBar: BlocConsumer<TodoBloc, TodoState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PrimaryColors.k600,
                  fixedSize: Size(size.width * .8, 40),
                ),
                onPressed: () {
                  if (taskController.text == "") {
                    ToastService().error("Please write something!");
                  } else if (existingTodo == "New") {
                    context.read<TodoBloc>().add(
                      AddTodo(
                        task: taskController.text,
                        category: state.category!,
                      ),
                    );
                    context.go(AppRoutes.home);
                  } else {
                    context.read<TodoBloc>().add(
                      UpdateTodo(
                        category: state.category!,
                        id: state.todos[int.parse(existingTodo ?? "0")].id,
                        task: taskController.text,
                        status:
                            state.todos[int.parse(existingTodo ?? "0")].status,
                      ),
                    );
                    context.go(AppRoutes.home);
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),

                AddTodoWidget(taskController: taskController),
                SizedBox(height: 40),

                BlocConsumer<TodoBloc, TodoState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return Wrap(
                      spacing: 8,
                      children: TodoCategories.values.map((cat) {
                        return FilterChipsWidget(
                          isSelected: cat == state.category,
                          value: cat.value,
                          onSelected: (isse) => context.read<TodoBloc>().add(
                            CheckCategories(cat),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
