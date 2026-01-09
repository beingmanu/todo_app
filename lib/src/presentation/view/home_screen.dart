import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_withbloc/src/config/router/router_helper.dart';
import 'package:todo_withbloc/src/config/router/routes.dart';
import 'package:todo_withbloc/src/presentation/bloc/login/login_bloc.dart';
import 'package:todo_withbloc/src/presentation/bloc/todo/todo_state.dart';
import 'package:todo_withbloc/src/presentation/widgets/todo_widget.dart';
import 'package:todo_withbloc/src/utils/constants/colors.dart';

import '../bloc/todo/todo_bloc.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.transparent,
        actions: [
          BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<LoginBloc>().add(DoLogOutEvent());
                  context.go(AppRoutes.login);
                },
                icon: Icon(Icons.logout),
              );
            },
          ),
        ],
      ),
      backgroundColor: PrimaryColors.k100,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(buildRoute(AppRoutes.todo, {"id": "A"})),
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocConsumer<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.todos.isEmpty) {
                  return const Center(
                    child: Text("No tasks yet! Tap + to add one."),
                  );
                }
                return Column(
                  children: [
                    ...List.generate(
                      state.todos.length,
                      (index) => GestureDetector(
                        onTap: () {
                          context.go(
                            buildRoute(AppRoutes.todo, {
                              "id": index.toString(),
                            }),
                          );
                        },
                        child: TodoWidget(todo: state.todos[index]),
                      ),
                    ),
                  ],
                );
              },
              listener: (context, state) {},
            ),
          ],
        ),
      ),
    );
  }
}

// void showTodoSheet(BuildContext context, {TodoData? existingTodo}) {
//   // If existingTodo is not null, it's an EDIT mode
//   final controller = TextEditingController(text: existingTodo?.text ?? "");
//   var category = existingTodo?.category ?? TodoCategories.personal;

//   showModalBottomSheet(
//     context: context,
//     builder: (context) => Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           TextField(
//             controller: controller,
//             decoration: InputDecoration(labelText: "Task"),
//           ),
//           // Add a Dropdown for Categories here...
//           ElevatedButton(
//             onPressed: () {
//               if (existingTodo == null) {
//                 context.read<TodoBloc>().add(
//                   AddTodo(task: controller.text, category: category),
//                 );
//               } else {
//                 final updated = TodoData(
//                   id: existingTodo.id,
//                   text: controller.text,
//                   category: category,
//                   status: existingTodo.status,
//                   time: DateTime.now().toIso8601String(),
//                 );
//                 context.read<TodoBloc>().add(UpdateTodo(updated));
//               }
//               Navigator.pop(context);
//             },
//             child: Text("Save"),
//           ),
//         ],
//       ),
//     ),
//   );
// }
