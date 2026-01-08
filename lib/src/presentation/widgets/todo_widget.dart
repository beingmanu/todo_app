import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/model/todo_model.dart';
import '../bloc/todo/todo_bloc.dart';
import '../bloc/todo/todo_event.dart';

class TodoWidget extends StatelessWidget {
  final TodoData todo;

  const TodoWidget({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    // Determine category color
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
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Category Color Indicator Strip
              Container(width: 6, color: categoryColor),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Category Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              todo.category.name,
                              style: TextStyle(
                                color: categoryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Time Stamp
                          Text(
                            DateFormat('jm').format(
                              DateTime.now(),
                            ), // Replace with todo.updatedAt
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Todo Task Text
                      Text(
                        todo.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: todo.status == TodoCompletion.done
                              ? Colors.grey
                              : Colors.black87,
                          decoration: todo.status == TodoCompletion.done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _ActionButton(
                            icon: Icons.edit_outlined,
                            color: Colors.blueGrey,
                            onTap: () => _showEditDialog(context),
                          ),
                          _ActionButton(
                            icon: Icons.delete_outline,
                            color: Colors.redAccent,
                            onTap: () =>
                                context.read<TodoBloc>().add(DeleteTodo(todo)),
                          ),
                          const SizedBox(width: 8),
                          // Done/Undone Button
                          ElevatedButton.icon(
                            onPressed: () =>
                                context.read<TodoBloc>().add(UpdateTodo(todo)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  todo.status == TodoCompletion.done
                                  ? Colors.grey
                                  : Colors.green,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: Icon(
                              todo.status == TodoCompletion.done
                                  ? Icons.undo
                                  : Icons.check,
                              size: 18,
                            ),
                            label: Text(
                              todo.status == TodoCompletion.done
                                  ? "Undone"
                                  : "Done",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    // Logic to open a bottom sheet or dialog to edit todo.task
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: 22),
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
    );
  }
}
