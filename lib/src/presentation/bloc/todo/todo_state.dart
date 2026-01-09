import 'package:equatable/equatable.dart';
import 'package:todo_withbloc/src/domain/model/todo_model.dart';

class TodoState extends Equatable {
  final List<TodoData> todos;
  final bool isLoading;
  final TodoCategories? category;

  const TodoState({
    this.todos = const [],
    this.isLoading = false,
    this.category,
  });

  int get total => todos.length;
  int get completed =>
      todos.where((t) => t.status == TodoCompletion.done).length;

  TodoState copyWith({
    List<TodoData>? todos,
    bool? isLoading,
    TodoCategories? category,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [todos, isLoading, category];
}
