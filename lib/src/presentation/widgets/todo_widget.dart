import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_withbloc/src/config/theme/app_themes.dart';
import '../../domain/model/todo_model.dart';
import '../bloc/todo/todo_bloc.dart';
import '../bloc/todo/todo_event.dart';

class TodoWidget extends StatelessWidget {
  final TodoData todo;

  const TodoWidget({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    Color categoryColor;
    switch (todo.category.name.toLowerCase()) {
      case 'work':
        categoryColor = Colors.blueAccent;
        break;
      case 'shopping':
        categoryColor = Colors.orangeAccent;
        break;
      default:
        categoryColor = Colors.greenAccent; // Personal
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: todo.status == TodoCompletion.done
            ? Colors.grey[50]
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) =>
              context.read<TodoBloc>().add(DeleteTodo(todo)),

          key: Key(todo.id.toString()),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 10, color: categoryColor),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                todo.text,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: AppTheme.lightTheme.textTheme.bodyMedium!
                                    .copyWith(
                                      color: todo.status == TodoCompletion.done
                                          ? Colors.grey
                                          : Colors.black87,
                                      decoration:
                                          todo.status == TodoCompletion.done
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              todo.category.name,
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ),
                          Spacer(),
                          Text(
                            DateFormat('jm').format(DateTime.parse(todo.time)),
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => context.read<TodoBloc>().add(
                              UpdateTodo(
                                category: todo.category,
                                id: todo.id,
                                task: todo.text,
                                status: todo.status == TodoCompletion.done
                                    ? TodoCompletion.incomplete
                                    : TodoCompletion.done,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),

                                transitionBuilder:
                                    (
                                      Widget child,
                                      Animation<double> animation,
                                    ) {
                                      // You can use different transitions, like a scale transition
                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                child: todo.status == TodoCompletion.done
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        // The key is crucial for AnimatedSwitcher to identify the change
                                        key: ValueKey<bool>(true),
                                        size: 30,
                                      )
                                    : Icon(
                                        Icons.circle_outlined,
                                        color: Colors.grey,
                                        size: 30,
                                        // The key is crucial for AnimatedSwitcher to identify the change
                                        key: ValueKey<bool>(false),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
